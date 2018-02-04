package entity;

import entity.Role;
import java.util.Date;
import javax.annotation.Generated;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@Generated(value="EclipseLink-2.5.0.v20130507-rNA", date="2018-01-08T10:11:05")
@StaticMetamodel(Notifications.class)
public class Notifications_ { 

    public static volatile SingularAttribute<Notifications, String> content;
    public static volatile SingularAttribute<Notifications, String> title;
    public static volatile SingularAttribute<Notifications, Date> time;
    public static volatile SingularAttribute<Notifications, Role> groupID;
    public static volatile SingularAttribute<Notifications, String> email;
    public static volatile SingularAttribute<Notifications, String> name;
    public static volatile SingularAttribute<Notifications, Integer> senderID;
    public static volatile SingularAttribute<Notifications, Integer> notiId;
    public static volatile SingularAttribute<Notifications, String> type;
    public static volatile SingularAttribute<Notifications, Integer> recipientID;
    public static volatile SingularAttribute<Notifications, Boolean> isUnread;

}