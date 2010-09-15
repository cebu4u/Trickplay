package trickplay;

import trickplay.User;

/**
 * Authority domain class. Generated by Grails Acegi plugin, but modified
 * to fix the User/Role many-to-many problem with Hibernate.
 * @author Garth
 */
class Role {

    //removed to fix the User/Role many-to-many problem with Hibernate.
    //static hasMany = [people: User];
    
    String description, authority;
    
    static constraints = {
        authority(blank: false, unique: true);
        description();
    }
}