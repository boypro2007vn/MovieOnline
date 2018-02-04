package entity;

import entity.Accounts;
import entity.Movies;
import javax.annotation.Generated;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@Generated(value="EclipseLink-2.5.0.v20130507-rNA", date="2018-01-08T10:11:05")
@StaticMetamodel(Favorites.class)
public class Favorites_ { 

    public static volatile SingularAttribute<Favorites, Integer> favoriteID;
    public static volatile SingularAttribute<Favorites, Movies> movieId;
    public static volatile SingularAttribute<Favorites, Accounts> accountId;
    public static volatile SingularAttribute<Favorites, Boolean> type;
    public static volatile SingularAttribute<Favorites, Boolean> follow;

}