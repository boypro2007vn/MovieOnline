/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package bean;

import entity.Accounts;
import entity.Favorites;
import entity.Movies;
import java.util.List;
import javax.ejb.Local;
import model.MovieDB;

/**
 *
 * @author namin
 */
@Local
public interface FavoritesFacadeLocal {

    void create(Favorites favorites);

    void edit(Favorites favorites);

    void remove(Favorites favorites);

    Favorites find(Object id);

    List<Favorites> findAll();

    List<Favorites> findRange(int[] range);

    int count();

    List<Favorites> getBookmarkListByAccount(Accounts userId);

    List<MovieDB> getListMovieBookMark(int userID);

    Favorites getMovieByAccountIdandMovieId(Accounts acc, Movies movie);

    List<Favorites> getListByFollowandMovie(boolean follow, Movies movie);
    
}
