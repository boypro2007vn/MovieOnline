/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package bean;

import entity.Comments;
import entity.Movies;
import java.util.List;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;

/**
 *
 * @author namin
 */
@Stateless
public class CommentsFacade extends AbstractFacade<Comments> implements CommentsFacadeLocal {
    @PersistenceContext(unitName = "MovieOnline-ejbPU")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public CommentsFacade() {
        super(Comments.class);
    }
    
    @Override
    public List<Comments> findCommentByMovieId(Movies movie) {
        Query q = em.createQuery("SELECT c FROM Comments c WHERE c.movieId = :movieId ORDER BY c.commentId DESC",Comments.class);
        q.setParameter("movieId", movie);
        return q.getResultList();
    }
}
