/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package controller;

import bean.EpisodeFacadeLocal;
import bean.MoviesFacadeLocal;
import com.google.gson.Gson;
import entity.Episode;
import entity.Movies;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import main.Encrypt;

/**
 *
 * @author namin
 */
@WebServlet(name = "DownloadMovieServlet", urlPatterns = {"/download"})
public class DownloadMovieServlet extends HttpServlet {
    @EJB
    private EpisodeFacadeLocal episodeFacade;
    @EJB
    private MoviesFacadeLocal moviesFacade;
   
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, NoSuchAlgorithmException {
        response.setContentType("text/html;charset=UTF-8");  
        PrintWriter out = response.getWriter(); 
        String action = request.getParameter("action");
        int id=0;
        try {
            id = Integer.parseInt(request.getParameter("id"));
            switch(action){
            case "2998b3232d29e8dc5a78d97a32ce83f556f3ed31b057077503df05641dd79158":{
                
                Movies movie = moviesFacade.find(id);
                List<Episode> listEpi = episodeFacade.getEpisodeByMovieIDStorePro(id); 
                if(movie==null || listEpi==null || listEpi.size()==0){
                    request.setAttribute("errorTitle", "MOVIE NOT FOUND");
                    request.setAttribute("errorBody", "The movie may have been removed or not exist.");
                    request.getRequestDispatcher("404.jsp").forward(request, response);
                }else{
                    request.setAttribute("detailMovie", movie);
                    request.setAttribute("episode", episodeFacade.getEpisodeByMovieIDStorePro(id));
                    request.getRequestDispatcher("u_download_movie.jsp").forward(request, response);
                }
            }
            break;
            case "68ff63fb82e0e5dfec2a8496bf9afef608ad639ed552e740268eb537fa52067f":{
                String episodeId  = request.getParameter("id");
                if(episodeId.equals(null) || episodeId.equals("") || episodeId.isEmpty()){
                    request.getRequestDispatcher("404.jsp").forward(request, response);
                }else{
                    try {
                        Episode epi = episodeFacade.find(Integer.parseInt(episodeId));
                        String resRe  = request.getParameter("res");
                        String res = resRe.equals("360")?epi.getRes360():epi.getRes480();
                        File f  = new File(getServletContext().getRealPath("moviesSource/"+"mv_"+epi.getMovieId().getMovieId()+"/"+String.valueOf(epi.getEpisodeName())+"/sd/"+res));

                        response.setContentType("APPLICATION/OCTET-STREAM");   
                        response.setHeader("Content-Disposition","attachment; filename=\"" + res + "\"");   

                        FileInputStream in = new FileInputStream(f);
                        int i;   
                        while ((i=in.read()) != -1) {  
                            out.write(i);   
                        }   
                        in.close();   
                        out.close();     
                        out.flush();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            }
            break;
                
            default:
                request.getRequestDispatcher("404.jsp").forward(request, response);
            break;
        }
        } catch (Exception e) {
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
        try {
            processRequest(request, response);
        } catch (NoSuchAlgorithmException ex) {
            Logger.getLogger(DownloadMovieServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
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
        try {
            processRequest(request, response);
        } catch (NoSuchAlgorithmException ex) {
            Logger.getLogger(DownloadMovieServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
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
