/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package controller;

import bean.AccountVipHistoryFacadeLocal;
import bean.AccountsFacadeLocal;
import bean.RoleFacadeLocal;
import entity.AccountVipHistory;
import entity.Accounts;
import entity.Role;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author namin
 */
@WebServlet(name = "LoginTemplateServlet", urlPatterns = {"/loginTemplate"})
public class LoginTemplateServlet extends HttpServlet {
    @EJB
    private RoleFacadeLocal roleFacade;
    @EJB
    private AccountsFacadeLocal accountsFacade;
    
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, ParseException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        String type = request.getParameter("type");
        if(type !=null){
            request.getSession().removeAttribute("user");
            response.sendRedirect(request.getParameter("pathname"));
        }else{
            String user = request.getParameter("txtUsername");
            Accounts acc = null;
            boolean flag = false;
            if(request.getCookies()!=null){
                Cookie[] cookies = request.getCookies();
                for(Cookie cookie:cookies){
                    if(cookie.getName().equals("loginCookie")){
                        if(user.equals(cookie.getValue())){
                            flag= true;
                            break;
                        }
                    }
                }
            }
            if(flag){
                acc = accountsFacade.getAccountByUsername(user);
            }else{
                String pass = request.getParameter("txtPassword");
                acc = accountsFacade.login(user, pass, true);
            }
            if(acc !=null){
                if(acc.getBanned()){
                    out.print("You have been banned. Reason: "+acc.getReasonBan());
                }else{
                    boolean remember = (request.getParameter("remember") !=null &&  !request.getParameter("remember").isEmpty())?true:false;
                    if(remember){
                        Cookie cookie = new Cookie("loginCookie",acc.getUserName());
                        cookie.setMaxAge(3600);
                        response.addCookie(cookie);
                    }
                    Date curDay = new Date();
                    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
                    Date vipend;
                    try {
                        vipend = format.parse(acc.getDayVipEnd());
                    } catch (Exception e) {
                        vipend = format.parse("1990-01-01");
                    }
                    Role role = acc.getRole();
                    
                    if(!role.getName().equals("ROLE_ADMIN") && !role.getName().equals("ROLE_UPLOADER")){
                        if(vipend.getTime() - curDay.getTime() < 0){
                            if(role.getName().equals("ROLE_VIP")){
                                Role memberRole = roleFacade.getRoleByName("ROLE_MEMBER");
                                if (memberRole != null) {
                                    acc.setRole(memberRole);
                                    accountsFacade.edit(acc);
                                }
                            }
                            
                        }else{
                            if(role.getName().equals("ROLE_MEMBER")){
                                Role vipRole = roleFacade.getRoleByName("ROLE_VIP");
                                if (vipRole != null) {
                                    acc.setRole(vipRole);
                                    accountsFacade.edit(acc);
                                }
                            }
                        }
                    }
                    request.getSession().setAttribute("user", acc);
                    out.print("success");
                }
            }else{
                out.print("Invalid username or password");
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
        try {
            processRequest(request, response);
        } catch (ParseException ex) {
            Logger.getLogger(LoginTemplateServlet.class.getName()).log(Level.SEVERE, null, ex);
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
        } catch (ParseException ex) {
            Logger.getLogger(LoginTemplateServlet.class.getName()).log(Level.SEVERE, null, ex);
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
