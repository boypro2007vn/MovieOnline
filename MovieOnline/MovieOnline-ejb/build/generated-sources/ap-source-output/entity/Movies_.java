package entity;

import entity.Comments;
import entity.Country;
import entity.Episode;
import entity.Favorites;
import entity.Genre;
import entity.Rating;
import javax.annotation.Generated;
import javax.persistence.metamodel.CollectionAttribute;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@Generated(value="EclipseLink-2.5.0.v20130507-rNA", date="2018-01-08T10:11:05")
@StaticMetamodel(Movies.class)
public class Movies_ { 

    public static volatile SingularAttribute<Movies, Country> countryId;
    public static volatile SingularAttribute<Movies, String> titleTag;
    public static volatile SingularAttribute<Movies, Integer> movieId;
    public static volatile SingularAttribute<Movies, String> trailer;
    public static volatile CollectionAttribute<Movies, Genre> genreCollection;
    public static volatile CollectionAttribute<Movies, Episode> episodeCollection;
    public static volatile SingularAttribute<Movies, Boolean> status;
    public static volatile CollectionAttribute<Movies, Favorites> favoritesCollection;
    public static volatile SingularAttribute<Movies, Double> imdb;
    public static volatile SingularAttribute<Movies, String> director;
    public static volatile SingularAttribute<Movies, Boolean> type;
    public static volatile SingularAttribute<Movies, String> realTitle;
    public static volatile SingularAttribute<Movies, String> actorAscii;
    public static volatile SingularAttribute<Movies, String> directorAscii;
    public static volatile CollectionAttribute<Movies, Comments> commentsCollection;
    public static volatile SingularAttribute<Movies, String> uploadDay;
    public static volatile SingularAttribute<Movies, String> duration;
    public static volatile SingularAttribute<Movies, String> title;
    public static volatile SingularAttribute<Movies, Integer> views;
    public static volatile SingularAttribute<Movies, String> description;
    public static volatile SingularAttribute<Movies, Boolean> ageLimit;
    public static volatile SingularAttribute<Movies, String> releaseDay;
    public static volatile SingularAttribute<Movies, String> quantity;
    public static volatile SingularAttribute<Movies, String> actors;
    public static volatile SingularAttribute<Movies, Boolean> vipOnly;
    public static volatile CollectionAttribute<Movies, Rating> ratingCollection;

}