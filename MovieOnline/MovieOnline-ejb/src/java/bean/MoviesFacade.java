/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package bean;

import entity.Accounts;
import entity.Movies;
import java.util.List;
import javax.ejb.Stateless;
import javax.naming.InitialContext;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;
import javax.persistence.StoredProcedureQuery;
import javax.transaction.UserTransaction;
import model.MovieDB;

/**
 *
 * @author namin
 */
@Stateless
public class MoviesFacade extends AbstractFacade<Movies> implements MoviesFacadeLocal {
    @PersistenceContext(unitName = "MovieOnline-ejbPU")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public MoviesFacade() {
        super(Movies.class);
    }

    @Override
    public MovieDB getDetailMovies(int id) {
        StoredProcedureQuery q = em.createNamedStoredProcedureQuery("Movies.getDetailMovie").setParameter("id", id);
        MovieDB movie;
        try {
            movie = (MovieDB)q.getSingleResult();
        } catch (Exception e) {
            return null;
        }
        return movie;
    }

    @Override
    public Movies createMovie(Movies entity) {
        em.persist(entity);
        em.flush();
        return entity;
    }

    @Override
    public List<Movies> getMovieByDayRange(String start, String end) {
        StoredProcedureQuery q = em.createNamedStoredProcedureQuery("Movies.getListMovieByDayRange").setParameter("start", start).setParameter("end", end);
        return q.getResultList();
    }

    @Override
    public int countView() {
        Query q = em.createNativeQuery("SELECT ISNULL(SUM(views),0) AS views FROM dbo.Movies");
        return Integer.parseInt(q.getSingleResult().toString());
    }

    @Override
    public int countMovieByDay(String day) {
        Query q = em.createNativeQuery("SELECT ISNULL(count(movieId),0) AS movie FROM dbo.Movies WHERE uploadDay = ?1");
        q.setParameter(1, day);
        return Integer.parseInt(q.getSingleResult().toString());
    }

    @Override
    public List<MovieDB> getListTrailerMovie() {
        StoredProcedureQuery q = em.createNamedStoredProcedureQuery("Movies.getListTrailerMovie");
        return q.getResultList();
    }

    @Override
    public List<MovieDB> getListMovieByType(int type,int num) {
        StoredProcedureQuery q = em.createNamedStoredProcedureQuery("Movies.getListMovieByType").setParameter("type", type).setParameter("num", num);
        return q.getResultList();
    }
    
    //searchMovie Tri

    @Override
    public List<MovieDB> searchMovie(int id, String title, String actor, String director, int type, int uploadday,int releaseday, String countryname, String genrename, int views) {
        StoredProcedureQuery q = em.createNamedStoredProcedureQuery("Movies.searchMovie");
        q.setParameter("id", id);
        q.setParameter("title", title);        
        q.setParameter("actor", actor);
        q.setParameter("director", director);
        q.setParameter("type", type);
        q.setParameter("uploadDay", uploadday);
        q.setParameter("releaseDay", releaseday);
        q.setParameter("countryName", countryname);
        q.setParameter("genreName", genrename);
        q.setParameter("views", views);
        return q.getResultList();
    }
    //TRI

    @Override
    public List<MovieDB> searchHeader(String title) {
        StoredProcedureQuery q = em.createNamedStoredProcedureQuery("Movies.searchHeader");
        q.setParameter("title", title);
        return q.getResultList();
    }

    @Override
    public List<MovieDB> getRelatedMovies(int id, String title, String genre, String actor, String country) {
        StoredProcedureQuery q = em.createNamedStoredProcedureQuery("Movies.relatedMovies");
        q.setParameter("id", id);
        q.setParameter("title", title);
        q.setParameter("genre", genre);
        q.setParameter("actor", actor);
        q.setParameter("country", country);
        return q.getResultList();
    }
    
    
}
