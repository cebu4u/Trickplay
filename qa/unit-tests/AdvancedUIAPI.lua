local log = print
-- Load the AdvancedUI Classes into a class table
local controller , class_table , CACHE_LOCAL_PROPERTIES = ...
if not class_table then
    class_table = dofile("AdvancedUIClasses.lua")
end

local foo = 0

assert(controller)
assert(class_table)

---------------------------------------------------------------------------
-- CACHE_LOCAL_PROPERTIES
--
-- If true, we cache local values of properties. Otherwise, we cache them
-- when we get them from the remote.
-- For example, if you set thing.color = "blue" and the remote end treats
-- that as "0000FF". Then, with this set to true, when you read thing.color
-- you would get "blue". With it set to false, you would get "0000FF".
-- So, false means more round trips to the remote, but more consistency.

---------------------------------------------------------------------------
-- The factory itself. We also add a reference to it in each proxy's metatable

local factory = {}

---------------------------------------------------------------------------
-- For each class in the class table, we create a convenience function that
-- creates a remote object and returns a proxy of the correct type.
-- So, if you have a class called Rectangle, you can call factory:Rectangle
-- to construct a new one.

for k , _ in pairs( class_table ) do
    factory[ k ] =
        function( factory , properties )
            return factory:create_remote( k , properties )
        end
end

---------------------------------------------------------------------------
-- Every local proxy we create is kept here, keyed by its id

local proxies = {}
-- the proxies have weak values
setmetatable(proxies, {__mode = "v"})

local function reset_proxies()

    -- prevent deallocation being sent over the network
    for id,proxy in pairs(proxies) do
        if proxy.marker then
            getmetatable(proxy.marker).__gc = nil
        end
    end
    
    proxies = {}
    setmetatable(proxies, {__mode = "v"})

end

---------------------------------------------------------------------------
-- This is how we talk to the remote end

local function send_request( end_point , payload )
    assert( type( end_point ) == "string" )

    payload = payload or {}

    payload.method = end_point
    --[[
    print("send_request payload:", payload)
    if type(payload) == "table" then
        dumptable(payload)
    end
    --]]
    result = controller:advanced_ui( payload )
    --[[
    foo = foo + 1
    --result = {id = foo}
    if foo%30 == 0 then
        print("\t\tcalls = ", foo)
    end
    --]]
    ---[[
    --print("send_request result:", result)
    if type(result) == "table" then
        --dumptable(result)
    end
    --]]

    if result == json.null then
        return nil
    end

    return result
end

---------------------------------------------------------------------------
-- This is a table that contains the metatables for each class. It starts
-- out empty and gets populated when new instances are created.
--
-- To create a new instance, you get its metatable by calling
--  proxy_metatables[ T ]
-- If such a metatable is not there, the __index function below gets called,
-- which creates the metatable for this type, stores it in proxy_metatables
-- and returns it.

local proxy_metatables = {}

do

    local mt = {}
    
    setmetatable( proxy_metatables , mt )


    function mt:__index( T )
    
        -- Get the tables of getters, setters and functions for this type
        -- from the class table.
    
        local get , set , call , event = class_table[ T ]()
        
        if not get or not set or not call or not event then
            error( string.format( "Invalid type '%s'" , T ) )
        end
        
        -- Create the metatable for the proxy object
        
        local proxy =
        {
            factory = factory
        }
        
        -- Store it
        
        rawset( proxy_metatables , T , proxy )
        
        -----------------------------------------------------------------------
        -- This is the __newindex metamethod for this proxy.
        
        function proxy:__newindex( key , value )
            
            -- See if there is a setter function for this property

            if key == "marker" then
                print("The key 'marker' is reserved for the garbage collector")
                return
            end
            
            -- Protect on_completeds
            if key == "on_completeds" then
                print("The key 'on_completeds' is reserved for animations")
                return
            end

            -- Protect event handlers

            if (key == "on_touches" or key == "on_loaded"
            or key == "on_text_changed") and value
            and type(value) ~= "function" then
                print("The key", key, "is reserved for functions only")
                return
            end

            if key == "__parent" then
                print("The key", key, "is reserved for referencing parents")
                return
            end

            local setter = rawget( set , key )
            if type( setter ) == "function" then
                setter( self , value )
                return
            end

            -- Setting it to nil means deleting the property
        
            if value == nil then
                -- See if it is an event function
                if rawget( self.__events , key ) then
                    rawset( self.__events , key , nil )
                    return
                end
                
                -- Clear it from the cache 
                --rawset( self.__pcache , key , nil )
                
                -- Tell the remote to delete it
                local payload = { id = self.id , properties = { [ key ] = true } }
                send_request( "delete" , payload )
                return
            end
            
            -- If it is a function, we store it in __events
            
            if type( value ) == "function" then
                rawset( self.__events , key , value )
                return
            end
            
            -- It cannot be a user data or thread 
            
            assert( type( value ) ~= "userdata" )
            assert( type( value ) ~= "thread" )
            
            -- Otherwise, set the remote property
            
            local payload = { id = self.id , properties = { [ key ] = value } }
            
            send_request( "set" , payload )

            --[[
            if CACHE_LOCAL_PROPERTIES then
                -- Put the local value in the cache
                rawset( self.__pcache , key , value )
            else
                -- Remove any value from the cache. We'll populate it
                -- as soon as we get it back from the remote.
                rawset( self.__pcache , key , nil )
            end
            --]]
        end
        
        -----------------------------------------------------------------------
        -- Returns the value of a property for this proxy.

        function proxy:__index( key )
            
            -- See if it is a property that has a getter
            
            value = rawget( get , key )
            if type( value ) == "function" then
                return value( self , key )
            end

            -- See if it is already in the metatable
            -- The 'factory' property is the only one so far.
            
            local value = rawget( proxy , key )                
            if value ~= nil then
                return value
            end
            
            -- See if it is a function
            
            value = rawget( call , key )
            if value ~= nil then
                return value
            end
            
            -- See if it is an event
            
            value = rawget( self.__events , key )
            if value ~= nil then
                return value
            end
            
            -- See if we have it cached
            --[[
            value = rawget( self.__pcache , key )
            if value ~= nil then
                return value
            end
            --]]
            
            -- OK, just fetch its value from the remote
        
            local payload = { id = self.id , properties = { [ key ] = true } }
            local result = send_request( "get" , payload )
            if not result then return nil end
            result = result.properties
            if not result then return nil end
            result = result[ key ]
            if result == nil or result == json.null then
                return nil
            end
            
            -- And cache it
            
            --rawset( self.__pcache , key , result )
            
            return result
        end
        
        -----------------------------------------------------------------------
        
        function proxy.__has_setter( key )
            return type( rawget( set , key ) ) == "function"
        end
        
        -----------------------------------------------------------------------
        -- Calls a remote function

        function proxy:__call( function_name , ... )
            local payload = { id = self.id , call = function_name , args = {...} }
            local result = send_request( "call" , payload )
            if result == nil then return nil end
            if not result.result then return nil end

            result = result.result
            if result == json.null then
                return nil
            end
            return result
        end
    
        return proxy
    end
    
end

---------------------------------------------------------------------------
-- Creates a local proxy. The metatable and property cache can be omitted

local function create_local( id , T , proxy_metatable , property_cache )

    -- If it already exists, return it
    if not id or not T then
        return nil
    end
    
    local proxy = rawget( proxies , id )
    
    if proxy ~= nil then
        return proxy
    end

    -- Get the metatable for it
    
    proxy_metatable = proxy_metatable or proxy_metatables[ T ]
    
    assert( type( proxy_metatable ) == "table" )
    
    -- Create the property cache table for it
    --[[
    if CACHE_LOCAL_PROPERTIES then
        
        -- Use what was passed in or a new table.
        
        property_cache = property_cache or {}
        
    else
        -- When we are NOT caching local properties, we ignore what was
        -- passed in for the property cache and create an empty one.
        
        property_cache = {}
        
    end
    --]]
    
    -- Here it is
    
    local events = {}

    proxy_table = {
        id = id,
        type = T,
        --__pcache = property,
        __events = events,
        __children = {}
    }

    proxy = setmetatable(proxy_table, proxy_metatable )
    
    -- Store it
    
    rawset( proxies , id , proxy )

    -- Set up garbage collection

    local destruction_marker = {}
    local destruction_payload = {
        id = id,
        type = T
    }
    destruction_marker.__gc = function()

        local absolute = send_request( "destroy" , destruction_payload )
        if absolute then absolute = absolute.destroyed end
        --print("absolut vodka?", absolute)
        rawset(proxies, id, nil)

    end

    -- If not the screen then it's destructable
    if id ~= 0 then
        rawset( proxy , "marker" , newudata(destruction_marker) )
    end

    return proxy
end

---------------------------------------------------------------------------
-- The metatable for the factory

local mt = {}

mt.__index = mt

---------------------------------------------------------------------------
-- Creates an object of the given type (and with the given initial properties)
-- on the remote end. Then, creates and returns a local proxy for it.

function mt:create_remote( T , properties )
    if T == "Controller" then
        return nil
    end

    local proxy = proxy_metatables[ T ]

    -- Bulk properties are simple properties that do not require a
    -- function call to be set. We set the initial values of all these
    -- in one go when we create the remote object.
    
    -- Function properties are those which are set via a setter function.
    -- We take these out and set them one by one after the proxy has been
    -- created - because they could have side-effects.
    
    local bulk_properties = {}
    local function_properties = {}

    if type( properties ) == "table" then
        local has_setter = proxy.__has_setter
        for k , v in pairs( properties ) do
            if k ~= "id" and k ~= "type" then
                if ( not has_setter( k ) ) and ( type( v ) ~= "function" ) then
                    assert( type( v ) ~= "userdata" )
                    assert( type( v ) ~= "thread" )
                    rawset( bulk_properties , k , v )
                else
                    rawset( function_properties , k , v )
                end
            end
        end
    end
    
    -- Create the remote object with the initial properties

    local payload = { type = T , properties = bulk_properties }
    
    local id = send_request( "create" , payload )
    if id then
        id = id.id
    end
    
    -- Create the local proxy
    
    local result = create_local( id , T , proxy , bulk_properties )
    
    -- Now, set the function properties
    
    if function_properties ~= nil then
        for k , v in pairs( function_properties ) do
            result[ k ] = v
        end
    end
    
    return result
end

---------------------------------------------------------------------------
-- Creates a local proxy to wrap the object of the given type and id.

function mt:create_local( id , T )

    return create_local( id , T )

end

---------------------------------------------------------------------------

---------------------------------------------------------------------------
-- List every proxy !

function mt:list()
    dumptable(proxies)
end

---------------------------------------------------------------------------

setmetatable( factory , mt )

---------------------------------------------------------------------------
-- Handle events for individual proxies

function controller:on_advanced_ui_event(json_object)
    if not json_object then
        return
    end

    if json_object.event == "reset_hard" then
        reset_proxies()
        return
    end

    local proxy = rawget( proxies , json_object.id )
    if not proxy then
        return
    end
    
    --[[
        events are:
        on_touches(touch_id_list, state)
        on_loaded(failed)
        on_text_changed(text)
        on_show()
        on_hide()
        on_completed()

        reset_hard
    --]]

    -- call the right callback for the event
    local events = rawget(proxy, "__events")
    local on_completeds = rawget(proxy, "on_completeds")
    if events[json_object.event] then
        json_object.args = json_object.args or {}
        events[json_object.event](proxy, unpack(json_object.args))
    elseif json_object.event == "on_completed" and on_completeds
    and on_completeds[json_object.animation_id] then
        on_completeds[json_object.animation_id]()
        on_completeds[json_object.animation_id] = nil
    end
end

---------------------------------------------------------------------------
-- Give the controller Container like abilities

controller.screen = factory:create_local(0, "Controller") 
controller.factory = factory

---------------------------------------------------------------------------

return factory
