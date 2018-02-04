/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package controller;

import bean.TypeVipFacadeLocal;
import entity.TypeVip;
import java.io.IOException;
import java.io.PrintWriter;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import main.Check;

/**
 *
 * @author ASUS
 */
@WebServlet(name = "AdminVipUpdatedServlet", urlPatterns = {"/AdminVipUpdated"})
public class AdminVipUpdatedServlet extends HttpServlet {
    @EJB
    private TypeVipFacadeLocal typeVipFacade;

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();        
        String error = "false";        
        String viptype = Check.removeSpace(request.getParameter("viptype")).trim();        
        int duration = 0;
        float price = 0;
        String priceStr ="";
        try {
            duration = Integer.parseInt(request.getParameter("duration"));
            priceStr = Check.removeComma(request.getParameter("price")); 
            System.out.println(priceStr);
            price = Float.parseFloat(priceStr);
        } catch (Exception e) {  
            e.printStackTrace();
            error = "true";
        }
        if(viptype.isEmpty() || viptype == null){
            error = "true";
        }
        if(error.equals("true")){
            out.print("true");
        }else{
            try {
                TypeVip typevip = typeVipFacade.find(Integer.parseInt(request.getParameter("vipid")));
                typevip.setName(viptype);
                typevip.setDuration(duration);
                typevip.setPrice(price);
                typeVipFacade.edit(typevip);
                out.print("false");
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
