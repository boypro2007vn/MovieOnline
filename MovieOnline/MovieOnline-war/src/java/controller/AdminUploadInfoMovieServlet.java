/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package controller;

import bean.CountryFacadeLocal;
import bean.GenreFacadeLocal;
import bean.MoviesFacadeLocal;
import bean.NotificationsFacadeLocal;
import bean.RoleFacadeLocal;
import entity.Accounts;
import entity.Genre;
import entity.Movies;
import entity.Notifications;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashSet;
import java.util.Set;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import main.Check;
import org.apache.commons.io.FileUtils;

/**
 *
 * @author namin
 */
@WebServlet(name = "AdminUploadInfoMovieServlet", urlPatterns = {"/adminUploadInfoMovie"})
public class AdminUploadInfoMovieServlet extends HttpServlet {
    @EJB
    private RoleFacadeLocal roleFacade;
    @EJB
    private NotificationsFacadeLocal notificationsFacade;
    @EJB
    private GenreFacadeLocal genreFacade;
    @EJB
    private CountryFacadeLocal countryFacade;
    @EJB
    private MoviesFacadeLocal moviesFacade;
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        String error = "false";
        String title = Check.removeSpace(request.getParameter("title").trim());
        String realTitle = Check.removeSpace(request.getParameter("realTitle").trim());
        String tag = Check.removeSpace(request.getParameter("tag").trim());
        String director = Check.removeSpace(request.getParameter("director").trim());
        String actor = Check.removeSpace(request.getParameter("actor").trim());
        String[] genre = request.getParameterValues("genreCb");
        String description = Check.removeSpace(request.getParameter("description").trim());
        String trailer = request.getParameter("trailer");
        if(trailer==null || trailer.isEmpty()){
            trailer= "empty";
        }
        String ageLimit = request.getParameter("ageLimit");
        String status = request.getParameter("status");
        double imbd =0;
        try {
            imbd = Double.parseDouble(request.getParameter("imbd"));
        } catch (Exception e) {
            imbd=0;
        }
        int country = 0;
        int MovieType = 0 ;
        int duration = 0;
        String releaseDay  ="";
        try {
            country = Integer.parseInt(request.getParameter("country"));
            MovieType = Integer.parseInt(request.getParameter("MovieType"));
            duration = Integer.parseInt(request.getParameter("duration"));
            releaseDay = Check.convertDay(request.getParameter("releaseDay"));
        } catch (Exception e) {
            error = "true";
        }
        if(title.isEmpty() || title == null || realTitle.isEmpty() || realTitle == null || genre.length ==0 || genre == null || director.isEmpty() || director == null || actor.isEmpty() || actor == null || releaseDay.length()==0 || releaseDay == null){
            error = "true";
        }
        
        if(error.equals("true")){
            out.print("true");
        }else{
            try {
                String movId = request.getParameter("movieId");
                Movies movie;
                if(movId !=null && movId !=""){
                    movie = moviesFacade.find(Integer.parseInt(movId));
                }else{
                    movie = new Movies();
                }
                movie.setTitle(title);
                movie.setRealTitle(realTitle);
                movie.setTitleTag(tag==null?"":tag);
                movie.setReleaseDay(releaseDay);
                movie.setCountryId(countryFacade.find(country));
                movie.setImdb(imbd);
                movie.setActors(actor);
                movie.setActorAscii(Check.removeAccent(actor));
                movie.setDirector(director);
                movie.setDirectorAscii(Check.removeAccent(director));
                movie.setDescription(description==null?"":description);
                movie.setType(MovieType == 0?false:true);
                movie.setDuration(String.valueOf(duration)+(MovieType == 0?" minutes":" episode"));
                movie.setViews(0);
                SimpleDateFormat format= new SimpleDateFormat("yyyy-MM-dd");
                movie.setUploadDay(format.format(new Date()));
                movie.setStatus(status!=null?true:false);
                movie.setQuantity("FullHD");
                movie.setAgeLimit(ageLimit!=null?true:false);
                movie.setVipOnly(false);
                Set<Genre> genres = new HashSet<Genre>();
                for(String var:genre){
                    genres.add(genreFacade.find(Integer.parseInt(var)));
                }
                movie.setGenreCollection(genres);
                String action = request.getParameter("actionMovie");
                if(action.equalsIgnoreCase("") || action == null){
                    out.print("true");
                }else{
                    if(action.equalsIgnoreCase("update")){
                        if(!trailer.equalsIgnoreCase("empty")){
                            movie.setTrailer(trailer.trim());
                        }
                        moviesFacade.edit(movie);
                        out.print("false");
                    }else{
                        if(action.equalsIgnoreCase("insert")){
                            movie.setTrailer(trailer.trim());
                            Movies insertedMovie = moviesFacade.createMovie(movie);
                            if(insertedMovie == null){
                                out.print("true");
                            }else{
                                File file = new File(getServletContext().getRealPath("/moviesSource/"+"mv_"+insertedMovie.getMovieId()));
                                if(!file.exists()){
                                    file.mkdir();
                                }
                                File fileImage = new File(getServletContext().getRealPath("/public/images/default-poster.jpg"));
                                FileUtils.copyFile(fileImage, new File(getServletContext().getRealPath("moviesSource/mv_"+insertedMovie.getMovieId()+"/poster.medium.jpg")));
                                Notifications noti = new Notifications();
                                Accounts acc = (Accounts)request.getSession().getAttribute("user");
                                if(acc != null && (acc.getRole().getName().equalsIgnoreCase("ROLE_ADMIN") || acc.getRole().getName().equalsIgnoreCase("ROLE_UPLOADER"))){
                                    noti.setSenderID(acc.getAccountId());
                                    noti.setName(acc.getUserName());
                                    noti.setEmail(acc.getEmail());
                                    noti.setRecipientID(0);
                                    noti.setGroupID(acc.getRole());
                                    noti.setTitle("UPLOAD MOVIE");
                                    noti.setContent("<span style='color:red'>"+acc.getUserName()+"</span> has been upload movie (ID: <span style='color:blue'>"+insertedMovie.getMovieId()+"</span> / Name: <span style='color:blue'>"+insertedMovie.getRealTitle()+"</span>)");
                                    noti.setType("SYSTEM-ADMIN");
                                    noti.setTime(new Timestamp(System.currentTimeMillis()));
                                    noti.setIsUnread(false);
                                    notificationsFacade.create(noti);
                                }
                                out.print(insertedMovie.getMovieId());
                            }
                        }else{
                            out.print("true");
                        }
                    }
                }
                
                
            } catch (Exception e) {
                out.print("true");
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
