package entity;

import entity.Movies;
import javax.annotation.Generated;
import javax.persistence.metamodel.CollectionAttribute;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@Generated(value="EclipseLink-2.5.0.v20130507-rNA", date="2018-01-08T10:11:05")
@StaticMetamodel(Genre.class)
public class Genre_ { 

    public static volatile CollectionAttribute<Genre, Movies> moviesCollection;
    public static volatile SingularAttribute<Genre, Integer> genreOrder;
    public static volatile SingularAttribute<Genre, String> genreName;
    public static volatile SingularAttribute<Genre, Integer> genreId;

}