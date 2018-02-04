/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package bean;

import entity.Accounts;
import entity.Movies;
import entity.Rating;
import java.util.List;
import javax.ejb.Local;

/**
 *
 * @author namin
 */
@Local
public interface RatingFacadeLocal {

    void create(Rating rating);

    void edit(Rating rating);

    void remove(Rating rating);

    Rating find(Object id);

    List<Rating> findAll();

    List<Rating> findRange(int[] range);

    int count();

    boolean checkAccountRating(Accounts accountID,Movies movieID);

    int getCountRatingByMovie(Movies movie);

    String getRatePointByMovie(Movies movie);

    List<Rating> getRatingByMovie(Movies id);
    
}
