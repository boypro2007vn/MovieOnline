/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package controller;

import bean.AccountsFacadeLocal;
import bean.RoleFacadeLocal;
import entity.Accounts;
import entity.Role;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author namin
 */
@WebServlet(name = "AdminLoginServlet", urlPatterns = {"/AdminLoginServlet"})
public class AdminLoginServlet extends HttpServlet {
    @EJB
    private AccountsFacadeLocal accountsFacade;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
            if(action.equalsIgnoreCase("Log in")){
                String error = "";
                String username = request.getParameter("username");
                String password = request.getParameter("password");
                if(username.trim().isEmpty() || password.trim().isEmpty()){
                    error +="<div class=\"alert alert-danger\">\n" +
                            "  <i class=\"fa fa-exclamation-triangle fa-fw\"></i> Please enter a username or password.\n" +
                            "</div>";
                }
                if(!error.equals("")){
                    request.setAttribute("error", error);
                    request.getRequestDispatcher("admin_page/admin_login.jsp").forward(request, response);
                }else{
                    Accounts acc = accountsFacade.login(username, password, false);
                    if(acc == null){
                        error +="<div class=\"alert alert-danger\">\n" +
                            "  <i class=\"fa fa-exclamation-triangle fa-fw\"></i> Invalid username or password.\n" +
                            "</div>";
                        request.setAttribute("error", error);
                        request.getRequestDispatcher("admin_page/admin_login.jsp").forward(request, response);
                    }else{
                        if(acc.getBanned()){
                            error +="<div class=\"alert alert-danger\">\n" +
                                "  <i class=\"fa fa-exclamation-triangle fa-fw\"></i> You have been banned\n" +
                                "</div>";
                                request.setAttribute("error", error);
                                request.getRequestDispatcher("admin_page/admin_login.jsp").forward(request, response);
                        }else{
                            Role role = accountsFacade.getRole(acc);
                            if(role.getName().equalsIgnoreCase("ROLE_ADMIN") || role.getName().equalsIgnoreCase("ROLE_UPLOADER")){
                                request.getSession().setAttribute("user", acc);
                                response.sendRedirect("admin");
                            }else{
                                error +="<div class=\"alert alert-danger\">\n" +
                                "  <i class=\"fa fa-exclamation-triangle fa-fw\"></i> Access Denied. You don't have permission for this page\n" +
                                "</div>";
                                request.setAttribute("error", error);
                                request.getRequestDispatcher("admin_page/admin_login.jsp").forward(request, response);
                            }
                        }
                        
                    }
                }
            }else{
                if(action.equalsIgnoreCase("logout")){
                    request.getSession().removeAttribute("user");
                    request.getRequestDispatcher("admin_page/admin_login.jsp").forward(request, response);
                }else{
                    request.getRequestDispatcher("admin_page/admin_login.jsp").forward(request, response);
                }
            }      
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
           doGet(request, response);
    }

}
