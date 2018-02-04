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
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;
import javax.persistence.TemporalType;

/**
 *
 * @author namin
 */
@Stateless
public class RatingFacade extends AbstractFacade<Rating> implements RatingFacadeLocal {
    @PersistenceContext(unitName = "MovieOnline-ejbPU")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public RatingFacade() {
        super(Rating.class);
    }

    @Override
    public boolean checkAccountRating(Accounts account,Movies movie) {
        Query q = em.createNamedQuery("Rating.findByMovieIdAndAccountsId",Rating.class);
        q.setParameter("accountId", account);
        q.setParameter("movieId", movie); 
        return q.getResultList().size()>0;      
    }

    @Override
    public int getCountRatingByMovie(Movies movie) {
        Query q = em.createNamedQuery("Rating.findByMovie",Rating.class);
        q.setParameter("movieId", movie);
        return q.getResultList().size();
    }

    @Override
    public String getRatePointByMovie(Movies movie) {
        Query q = em.createQuery("select AVG(r.star) from Rating r where r.movieId = :movieId");
        q.setParameter("movieId", movie);
        return q.getResultList().get(0).toString();
    }

    @Override
    public List<Rating> getRatingByMovie(Movies id) {
        Query q = em.createNamedQuery("Rating.findByMovie");
        q.setParameter("movieId", id);
        return q.getResultList();
    }
    
    
    
    
    
}
