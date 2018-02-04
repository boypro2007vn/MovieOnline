/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package controller;

import bean.CommentsFacadeLocal;
import bean.EpisodeFacadeLocal;
import bean.MoviesFacadeLocal;
import bean.RatingFacadeLocal;
import entity.Comments;
import entity.Episode;
import entity.Genre;
import entity.Movies;
import entity.Rating;
import java.io.IOException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map.Entry;
import java.util.Random;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import main.Common;
import model.MovieDB;

/**
 *
 * @author namin
 */
@WebServlet(name = "MovieDetailServlet", urlPatterns = {"/movies"})
public class MovieDetailServlet extends HttpServlet {
    @EJB
    private CommentsFacadeLocal commentsFacade;
    @EJB
    private RatingFacadeLocal ratingFacade;
    @EJB
    private EpisodeFacadeLocal episodeFacade;
    @EJB
    private MoviesFacadeLocal moviesFacade;
    
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String error =null;
        int id =0;
        try {
            id = Integer.parseInt(request.getParameter("id"));
        } catch (Exception e) {
            error = "Error format";
        }
        if(error==null){
            try {
                MovieDB movie = moviesFacade.getDetailMovies(id);
                if(movie==null || !movie.isStatus()){
                    request.setAttribute("errorTitle", "MOVIE NOT FOUND");
                    request.setAttribute("errorBody", "The movie may have been removed or not exist.");
                    request.getRequestDispatcher("404.jsp").forward(request, response);
                }else{
                    String[] dur = movie.getDuration().split("\\s+");
                    if(dur[0].equals("0")){
                        movie.setDuration("???");
                    }
                    request.setAttribute("detailMovie", movie);
                    LinkedHashMap<String,Integer> ratingList = Common.getRatingList();
                    List<Rating> ratingL = ratingFacade.getRatingByMovie(moviesFacade.find(movie.getMovieId()));
                    if(ratingL.size()>0){
                        List<Entry<String,Integer>> randAccess = new ArrayList<Entry<String,Integer>>(ratingList.entrySet());
                        for(Rating rate : ratingL){
                            String key = randAccess.get(rate.getStar()-1).getKey();
                            ratingList.put(key, ratingList.get(key)+1);
                        }
                    }
                    Movies movieEntity = moviesFacade.find(id);
                    List<Comments> commentList = commentsFacade.findCommentByMovieId(movieEntity);
                    
                    int randomGenre = new Random().nextInt(movieEntity.getGenreCollection().size());
                    String[] listActor = movieEntity.getActors().split(",");
                    int randomActor = new Random().nextInt(listActor.length);
                    List<MovieDB> resMovie = moviesFacade.getRelatedMovies(movieEntity.getMovieId(), movieEntity.getRealTitle(), ((List<Genre>)movieEntity.getGenreCollection()).get(randomGenre).getGenreName(), listActor[randomActor], movie.getCountryName());
                    
                    request.setAttribute("commentList", commentList);
                    request.setAttribute("ratingList", ratingList);
                    request.setAttribute("recomenderList", resMovie);
                    request.getRequestDispatcher("u_detail_movie.jsp").forward(request, response);
                }
                
            } catch (Exception e) {
                request.getRequestDispatcher("404.jsp").forward(request, response);
            }
        }else{
            request.getRequestDispatcher("404.jsp").forward(request, response);
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
