/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package bean;

import entity.Accounts;
import entity.Movies;
import java.util.List;
import javax.ejb.Local;
import model.MovieDB;

/**
 *
 * @author namin
 */
@Local
public interface MoviesFacadeLocal {

    void create(Movies movies);

    void edit(Movies movies);
    
    void remove(Movies movies);

    Movies find(Object id);

    List<Movies> findAll();

    List<Movies> findRange(int[] range);

    int count();

    MovieDB getDetailMovies(int id);

    Movies createMovie(Movies entity);

    List<Movies> getMovieByDayRange(String start, String end);

    int countView();

    int countMovieByDay(String day);

    List<MovieDB> getListTrailerMovie();

    List<MovieDB> getListMovieByType(int type,int num);
    
    List<MovieDB> searchMovie(int id, String title, String actor, String director, int type, int uploadday,int releaseday, String countryname, String genrename, int views);

    List<MovieDB> searchHeader(String title);

    List<MovieDB> getRelatedMovies(int id, String title, String genre, String actor, String country);
}
