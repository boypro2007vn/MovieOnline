/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package bean;

import entity.Episode;
import entity.Movies;
import java.util.List;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;
import javax.persistence.StoredProcedureQuery;

/**
 *
 * @author namin
 */
@Stateless
public class EpisodeFacade extends AbstractFacade<Episode> implements EpisodeFacadeLocal {
    
    @PersistenceContext(unitName = "MovieOnline-ejbPU")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public EpisodeFacade() {
        super(Episode.class);
    }

    @Override
    public List<Episode> getEpisodeByMovieIDStorePro(int movieId) {
        StoredProcedureQuery q = em.createNamedStoredProcedureQuery("Episode.getEpisodeByMovieIDStorePro");
        q.setParameter("movieId", movieId);
        return q.getResultList();
    }

    @Override
    public Episode createEpisode(Episode entity) {
        em.persist(entity);
        em.flush();
        return entity;
    }

    @Override
    public List<Episode> getAllEpisodeByMovieID(Movies movieID) {
        Query q = em.createNamedQuery("Episode.findByMovieId").setParameter("movieId", movieID);
        return q.getResultList();
    }

    @Override
    public List<String> getListEpisodeByMovieIdGroupByEpisodeName(Movies movies) {
        Query q = em.createQuery("select c.episodeName,c.subtitle from Episode c where c.movieId=:movieId group by c.episodeName,c.subtitle").setParameter("movieId", movies);
        return q.getResultList();
    }

    @Override
    public List<Episode> getListByMovieIdandEpisodeName(Movies movieId, double episodeName) {
        Query q = em.createNamedQuery("Episode.findByMovieIdandEpisodeName").setParameter("movieId", movieId).setParameter("episodeName", episodeName);
        return q.getResultList();
    }
}
