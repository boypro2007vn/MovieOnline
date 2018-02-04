/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package controller;

import bean.AccountsFacadeLocal;
import bean.FavoritesFacadeLocal;
import bean.MoviesFacadeLocal;
import entity.Accounts;
import entity.Favorites;
import entity.Movies;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import main.Check;
import model.MovieDB;

/**
 *
 * @author namin
 */
@WebServlet(name = "BookMarkServlet", urlPatterns = {"/bookmark"})
public class BookMarkServlet extends HttpServlet {
    @EJB
    private MoviesFacadeLocal moviesFacade;
    @EJB
    private AccountsFacadeLocal accountsFacade;
    @EJB
    private FavoritesFacadeLocal favoritesFacade;

    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        String action = request.getParameter("action");
        String result = "";
        int userID = 0;
        Accounts accSessson = (Accounts)request.getSession().getAttribute("user");
        if(accSessson ==null){
            request.getRequestDispatcher("404.jsp").forward(request, response);
        }else{
            if(action.equals("add")){
                List<Favorites> list =favoritesFacade.getBookmarkListByAccount(accSessson);
                int movieId = Integer.parseInt(request.getParameter("movieId"));
                boolean flag = false;
                for(Favorites fav : list){
                    if(fav.getMovieId().getMovieId() == movieId){
                        flag = true;
                    }
                }
                if(flag){
                    result = "exist";
                }else{
                    Movies movie = moviesFacade.find(movieId);
                    Favorites fav = new Favorites();
                    fav.setAccountId(accSessson);
                    fav.setMovieId(movie);
                    fav.setFollow(false);
                    fav.setType(movie.getType());
                    favoritesFacade.create(fav);
                    result ="true";
                }
                out.print(result);
            }else{
                if(action.equals("get")){
                    List<MovieDB> list = favoritesFacade.getListMovieBookMark(accSessson.getAccountId());
                    request.setAttribute("bookmarkList", list);
                    request.getRequestDispatcher("u_moviebox.jsp").forward(request, response);
                }else{
                    int movieId = Integer.parseInt(request.getParameter("movieId"));
                    Movies movie = moviesFacade.find(movieId);
                    Favorites fac = favoritesFacade.getMovieByAccountIdandMovieId(accSessson, movie);
                    if(action.equals("follow")){
                        boolean change = request.getParameter("change").equals("true")?true:false;
                        fac.setFollow(change);
                        favoritesFacade.edit(fac);
                        out.print("true");
                    }else{
                        if(action.equals("remove")){
                            favoritesFacade.remove(fac);
                            out.print("true");
                        }else{
                            request.getRequestDispatcher("404.jsp").forward(request, response);
                        }
                        
                    }
                }
            }
            out.close();
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
