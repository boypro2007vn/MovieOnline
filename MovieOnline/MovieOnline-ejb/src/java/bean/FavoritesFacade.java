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
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;
import javax.persistence.StoredProcedureQuery;
import model.MovieDB;

/**
 *
 * @author namin
 */
@Stateless
public class FavoritesFacade extends AbstractFacade<Favorites> implements FavoritesFacadeLocal {
    @PersistenceContext(unitName = "MovieOnline-ejbPU")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public FavoritesFacade() {
        super(Favorites.class);
    }

    @Override
    public List<Favorites> getBookmarkListByAccount(Accounts acc) {
        Query q = em.createNamedQuery("Favorites.findByAccountId");
        q.setParameter("accountId", acc);
        return q.getResultList();
    }

    @Override
    public List<MovieDB> getListMovieBookMark(int userID) {
        StoredProcedureQuery q = em.createNamedStoredProcedureQuery("Movies.getMovieBox").setParameter("userID", userID);
        return q.getResultList();
    }

    @Override
    public Favorites getMovieByAccountIdandMovieId(Accounts acc, Movies movie) {
        Query q = em.createNamedQuery("Favorites.findByAccountIdandMovieId");
        q.setParameter("accountId", acc);
        q.setParameter("movieId", movie);
        Favorites fac  =null;
        try {
            fac =(Favorites)q.getSingleResult();
        } catch (Exception e) {
            return null;
        }
        return fac;
    } 

    @Override
    public List<Favorites> getListByFollowandMovie(boolean follow, Movies movie) {
        Query q = em.createNamedQuery("Favorites.findByFollowandMovie");
        q.setParameter("follow", follow);
        q.setParameter("movieId", movie);
        return q.getResultList();
    }
    
    
}
