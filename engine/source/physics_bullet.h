#ifndef _TRICKPLAY_PHYSICS_BULLET_H
#define _TRICKPLAY_PHYSICS_BULLET_H

#include "btBulletDynamicsCommon.h"

#include "common.h"
#include "app.h"

namespace Bullet
{
	class World
	{
	public:

		World( lua_State * L , float pixels_per_meter );

		~World();

        inline float world_to_screen( float coordinate ) const
        {
            return coordinate * ppm;
        }

        inline float screen_to_world( float coordinate ) const
        {
            return coordinate / ppm;
        }

        inline float get_ppm() const
        {
        	return ppm;
        }

        btDynamicsWorld * get_world() const
        {
        	return world;
        }

        int create_body( int element , int properties , const char * metatable );

        int create_body_3d( int properties );

        int create_shape( btCollisionShape * shape );

        void step( float time_step , int max_sub_steps , float fixed_time_step );

	private:

		LuaStateProxy *				lsp;

		float 						ppm;

		btCollisionDispatcher *		dispatcher;
		btBroadphaseInterface *		pair_cache;
		btConstraintSolver *		solver;
		btCollisionConfiguration * 	collision_configuration;

		btDynamicsWorld *			world;

		typedef btAlignedObjectArray< btCollisionShape * > ShapeArray;

		ShapeArray					shapes;
	};
};

#endif // _TRICKPLAY_PHYSICS_BULLET_H