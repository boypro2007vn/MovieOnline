/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;

import bean.AccountsFacadeLocal;
import bean.CommentsFacadeLocal;
import bean.MoviesFacadeLocal;
import com.google.gson.Gson;
import entity.Accounts;
import entity.Comments;
import entity.Movies;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.ejb.EJB;
import javax.json.Json;
import javax.json.JsonArray;
import javax.json.JsonArrayBuilder;
import javax.json.JsonObjectBuilder;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.JSONException;
import org.json.JSONObject;

/**
 *
 * @author ASUS
 */
@WebServlet(name = "UserCommentServlet", urlPatterns = {"/UserComment"})
public class UserCommentServlet extends HttpServlet {

    @EJB
    private MoviesFacadeLocal moviesFacade;
    @EJB
    private AccountsFacadeLocal accountsFacade;
    @EJB
    private CommentsFacadeLocal commentsFacade;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, JSONException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        JsonArray jsonArray = null;
        int movieId = Integer.parseInt(request.getParameter("movieId"));
        Movies movie = moviesFacade.find(movieId);
        try {
            int userId = Integer.parseInt(request.getParameter("userId"));
            Accounts acc = accountsFacade.find(userId);            
            String content = request.getParameter("commentContent");
            System.out.println(content);
            StringBuffer text = new StringBuffer(content);
            int loc = (new String(text)).indexOf('\n');
            while(loc > 0){
                text.replace(loc, loc+1, "<BR>");
                loc = (new String(text)).indexOf('\n');
            }
            Date time = new Date();
            Comments cmt = new Comments();
            cmt.setAccountId(acc);
            cmt.setMovieId(movie);
            cmt.setContent(text.toString());
            cmt.setTime(time);
            commentsFacade.create(cmt);            
            List<Comments> commentList = commentsFacade.findCommentByMovieId(movie);
            JsonArrayBuilder jsonBuilder = Json.createArrayBuilder();
            for(Comments comments: commentList){
                JsonObjectBuilder jsonObject = Json.createObjectBuilder()
                        .add("commentid", comments.getCommentId())
                        .add("accountid", comments.getAccountId().getAccountId())
                        .add("accountname", comments.getAccountId().getUserName())
                        .add("time",comments.getTime().toString())
                        .add("content",comments.getContent());
                jsonBuilder.add(jsonObject);
            }
            jsonArray = jsonBuilder.build();            
            out.print(jsonArray.toString());
        } catch (Exception e) {
            out.print("false");            
        }
        out.close();
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
        } catch (JSONException ex) {
            Logger.getLogger(UserCommentServlet.class.getName()).log(Level.SEVERE, null, ex);
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
        } catch (JSONException ex) {
            Logger.getLogger(UserCommentServlet.class.getName()).log(Level.SEVERE, null, ex);
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
