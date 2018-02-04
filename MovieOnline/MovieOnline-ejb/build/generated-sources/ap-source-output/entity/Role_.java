package entity;

import entity.Accounts;
import entity.Notifications;
import javax.annotation.Generated;
import javax.persistence.metamodel.CollectionAttribute;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@Generated(value="EclipseLink-2.5.0.v20130507-rNA", date="2018-01-08T10:11:05")
@StaticMetamodel(Role.class)
public class Role_ { 

    public static volatile CollectionAttribute<Role, Accounts> accountsCollection;
    public static volatile SingularAttribute<Role, String> color;
    public static volatile SingularAttribute<Role, String> name;
    public static volatile CollectionAttribute<Role, Notifications> notificationsCollection;
    public static volatile SingularAttribute<Role, Integer> roleId;

}