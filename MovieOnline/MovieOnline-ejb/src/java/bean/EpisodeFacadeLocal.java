/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package bean;

import entity.Episode;
import entity.Movies;
import java.util.List;
import javax.ejb.Local;

/**
 *
 * @author namin
 */
@Local
public interface EpisodeFacadeLocal {

    void create(Episode episode);

    void edit(Episode episode);

    void remove(Episode episode);

    Episode find(Object id);

    List<Episode> findAll();

    List<Episode> findRange(int[] range);

    int count();

    List<Episode> getEpisodeByMovieIDStorePro(int movieId);

    Episode createEpisode(Episode entity);

    List<Episode> getAllEpisodeByMovieID(Movies movieID);

    List<String> getListEpisodeByMovieIdGroupByEpisodeName(Movies id);

    List<Episode> getListByMovieIdandEpisodeName(Movies movieId, double episodeName);

    
}
