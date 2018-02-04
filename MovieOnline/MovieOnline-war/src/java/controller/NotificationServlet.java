/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package controller;

import bean.NotificationsFacadeLocal;
import bean.RoleFacadeLocal;
import com.google.gson.Gson;
import entity.Accounts;
import entity.Notifications;
import entity.Role;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Timestamp;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.ejb.EJB;
import javax.json.JsonArray;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import main.Message;
import main.NotiAdminClient;
import org.json.JSONArray;
import org.json.JSONException;

/**
 *
 * @author namin
 */
@WebServlet(name="NotificationServlet", urlPatterns={"/notificationServlet"})
public class NotificationServlet extends HttpServlet {
    @EJB
    private RoleFacadeLocal roleFacade;
    @EJB
    private NotificationsFacadeLocal notificationsFacade;
   
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, JSONException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        String typeRequest = request.getParameter("type");
        switch(typeRequest){
            case "getCountNoti":{
                JSONArray arr = new JSONArray(notificationsFacade.getCountNoti());
                out.print(arr.toString());
                break;
            }
            case "isNoti":{
                out.print(notificationsFacade.haveNoti("SYSTEM-ADMIN",false));
                break;
            }
            case "searchnoti":{
                int idString = -1;
                int recipient= -1;
                try {
                    idString = Integer.parseInt(request.getParameter("id"));
                } catch (Exception e) {
                    idString = -1;
                }
                
                String title = "";
                if(request.getParameter("title")!=null){
                    title =request.getParameter("title");
                };
                
                try {
                    recipient = Integer.parseInt(request.getParameter("recipient"));
                } catch (Exception e) {
                    recipient= -1;
                }
                
                String type = "";;
                if(request.getParameter("notitype")!=null){
                    type =request.getParameter("notitype");
                };
                
                int isread = -1;
                try {
                    isread = Integer.parseInt(request.getParameter("isread"));
                } catch (Exception e) {
                    isread = -1;
                }
                
                request.setAttribute("typeNoti", title);
                request.setAttribute("list", notificationsFacade.searchNoti(idString, title, recipient, type, isread));
                request.getRequestDispatcher("admin_page/admin_notification.jsp").forward(request, response);
                break;
            }
            case "report-error":{
                String movieID = request.getParameter("movieID");
                String type = request.getParameter("typeError");
                String typeError ="";
                switch(type){
                    case "1":{
                        typeError = "Cannot Watching Movie";
                        break;
                    }
                    case "2":{
                        typeError = "Don't Have Subtitle";
                        break;
                    }
                    case "3":{
                        typeError = "Other";
                        break;
                    }
                }
                String title = request.getParameter("title");
                String time = request.getParameter("time");
                String content = request.getParameter("errorContent");
                if(content == null){
                    content = "empty";
                }
                
                Accounts acc = (Accounts)request.getSession().getAttribute("user");
                String name = "Guest",email = "";
                Role role = roleFacade.find(4);
                System.out.println(request.getRemoteAddr());
                int senderID = Integer.parseInt(request.getRemoteAddr().replaceAll(":", "").replaceAll("\\.", ""));
                Timestamp timeRequest = new Timestamp(System.currentTimeMillis());
                if(acc !=null){
                    senderID = acc.getAccountId();
                    name = acc.getUserName();
                    email = acc.getEmail();
                    role = acc.getRole();
                }
                if(notificationsFacade.checkSender(senderID, timeRequest,title)){
                    out.print("spam");
                }else{
                    Notifications noti = new Notifications();
                    noti.setSenderID(senderID);
                    noti.setName(name);
                    noti.setEmail(email);
                    noti.setRecipientID(0);
                    noti.setGroupID(role);
                    noti.setTitle("ERROR REPORT");
                    noti.setContent("<span style='color:red'>"+name+"</span> send report error for movie (ID: <span style='color:blue'>"+movieID+"</span>) <p><strong>Type: </strong>"+typeError+"</br><strong>Time: </strong>"+time+"</br><strong>Content: </strong>"+content+"</p>");
                    noti.setType("SYSTEM-ADMIN");
                    noti.setTime(timeRequest);
                    noti.setIsUnread(false);
                    try {
                        notificationsFacade.create(noti);
                        NotiAdminClient notiSocket = new NotiAdminClient();
                        Thread.sleep(5000);
                        Message msg = new Message();
                        msg.setSubject("system-admin");
                        msg.setContent("<span style='color:red'>"+name+"</span> send report error for movie (ID: <span style='color:blue'>"+movieID+"</span>) <p><strong>Type: </strong>"+typeError+"</br><strong>Time: </strong>"+time+"</br><strong>Content: </strong>"+content+"</p>");
                        notiSocket.sendMessage(msg);
                        out.print("false");
                    } catch (Exception e) {
                        out.print("true");
                    }
                }
                break;
            }
            case "changeSeen":{
                int id =0;
                try {
                    id = Integer.parseInt(request.getParameter("notiID"));
                    Notifications noti = notificationsFacade.find(id);
                    if(noti!=null){
                        noti.setIsUnread(true);
                        notificationsFacade.edit(noti);
                        out.print("success");
                    }else{
                        throw new Exception("Cannot find this notification");
                    }
                } catch (Exception e) {
                    out.print(e.getMessage());
                }
                break;
            }
            default:
                request.getRequestDispatcher("404.jsp").forward(request, response);
                break;
        }
    } 

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (JSONException ex) {
            Logger.getLogger(NotificationServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (JSONException ex) {
            Logger.getLogger(NotificationServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
