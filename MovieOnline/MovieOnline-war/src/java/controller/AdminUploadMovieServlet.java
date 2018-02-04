/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package controller;

import bean.CountryFacadeLocal;
import bean.EpisodeFacadeLocal;
import bean.GenreFacadeLocal;
import bean.MoviesFacadeLocal;
import entity.Episode;
import entity.Movies;
import java.io.IOException;
import java.util.List;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import main.Check;

/**
 *
 * @author namin
 */
@WebServlet(name = "AdminUploadMovieServlet", urlPatterns = {"/adminUploadMovie"})
public class AdminUploadMovieServlet extends HttpServlet {
    @EJB
    private EpisodeFacadeLocal episodeFacade;
    @EJB
    private MoviesFacadeLocal moviesFacade;
    @EJB
    private GenreFacadeLocal genreFacade;
    @EJB
    private CountryFacadeLocal countryFacade;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("countrySl", countryFacade.findAll());
        request.setAttribute("genreCb", genreFacade.findAll());
        String action = request.getParameter("action");
        if(action.equalsIgnoreCase("upload")){
            request.getRequestDispatcher("admin_page/admin_upload_movie.jsp").forward(request, response);
        }else{
            if(action.equalsIgnoreCase("update")){
                int id = 0;
                try {
                    id = Integer.parseInt(request.getParameter("id"));
                    Movies movie = moviesFacade.find(id);
                    if(movie !=null){
                        request.setAttribute("movieDetail", movie);
                        String urlTrailer = movie.getTrailer();
                        if(Check.checkUrl(urlTrailer)){
                            request.setAttribute("urlTrailer", urlTrailer);
                        }
                        request.setAttribute("curEpisode", episodeFacade.getAllEpisodeByMovieID(movie));
                        request.getRequestDispatcher("admin_page/admin_update_movie.jsp").forward(request, response);
                    }else{
                        request.getRequestDispatcher("404.jsp").forward(request, response);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
                
            }else{
                request.getRequestDispatcher("404.jsp").forward(request, response);
            }
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
