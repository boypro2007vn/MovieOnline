/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package main;

import java.io.IOException;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.json.JsonObject;
import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;

@ServerEndpoint(
    value="/adminnoti",
    encoders = { MessageEncode.class }, 
    decoders = { MessageDecode.class }    
)
public class NotiAdminServer {
    static Set<Session> listSession = new HashSet<Session>();
    @OnOpen
    public void onOpen(Session session) {
        listSession.add(session);
        System.out.println("WebSocket opened: " + session.getId());
    }
    
    @OnClose
    public void onClose(Session session) {
       listSession.remove(session);
    }
    
    @OnError
        public void onError(Throwable error) {
            Logger.getLogger(NotiAdminServer.class.getName()).log(Level.SEVERE, null, error);
    }
        
    @OnMessage
    public void onMessage(Session session,Message message) throws IOException {
        try {
            Iterator<Session> ite = listSession.iterator();
            while(ite.hasNext()){
                ite.next().getBasicRemote().sendObject(message);
            } 
        } catch (Exception e) {
            e.printStackTrace();
        }
        
    }
    
}
