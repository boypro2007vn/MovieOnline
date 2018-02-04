package entity;

import entity.Accounts;
import entity.Movies;
import java.util.Date;
import javax.annotation.Generated;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@Generated(value="EclipseLink-2.5.0.v20130507-rNA", date="2018-01-08T10:11:05")
@StaticMetamodel(Comments.class)
public class Comments_ { 

    public static volatile SingularAttribute<Comments, String> content;
    public static volatile SingularAttribute<Comments, Date> time;
    public static volatile SingularAttribute<Comments, Movies> movieId;
    public static volatile SingularAttribute<Comments, Accounts> accountId;
    public static volatile SingularAttribute<Comments, Integer> commentId;

}