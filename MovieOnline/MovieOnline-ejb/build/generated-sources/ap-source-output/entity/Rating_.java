package entity;

import entity.Accounts;
import entity.Movies;
import javax.annotation.Generated;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@Generated(value="EclipseLink-2.5.0.v20130507-rNA", date="2018-01-08T10:11:05")
@StaticMetamodel(Rating.class)
public class Rating_ { 

    public static volatile SingularAttribute<Rating, Movies> movieId;
    public static volatile SingularAttribute<Rating, Accounts> accountId;
    public static volatile SingularAttribute<Rating, Integer> star;
    public static volatile SingularAttribute<Rating, Integer> ratingId;

}