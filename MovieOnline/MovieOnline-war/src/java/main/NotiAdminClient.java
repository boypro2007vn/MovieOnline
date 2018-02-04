/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package main;

import java.io.IOException;
import java.net.URI;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.json.JsonObject;
import javax.json.spi.JsonProvider;
import javax.websocket.ClientEndpoint;
import javax.websocket.ContainerProvider;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;

/**
 *
 * @author namin
 */
@ClientEndpoint(
    encoders = { MessageEncode.class }, 
    decoders = { MessageDecode.class } 
)
public class NotiAdminClient {
    Session session = null;
    private MessageHandler messageHandler;
    public NotiAdminClient(){
        try {
            URI uri = new URI("ws://localhost:8080/MovieOnline-war/adminnoti");
            ContainerProvider.getWebSocketContainer().connectToServer(this, uri);
        } catch (Exception e) {
            e.printStackTrace();
        }
        
    }
    @OnOpen
    public void open(Session session){
        this.session = session;
    }

    @OnError
    public void onError(Throwable error) {
        Logger.getLogger(NotiAdminServer.class.getName()).log(Level.SEVERE, null, error);
    }
    
    @OnMessage
    public void onMessage(String message) {
        if (this.messageHandler != null)
            this.messageHandler.handleMessage(message);
    }
    
    public void addMessageHandler(MessageHandler msgHandler) {
        this.messageHandler = msgHandler;
    }
    
    public void sendMessage(Message message) throws IOException{
        try {
            session.getBasicRemote().sendObject(message);
        } catch (Exception e) {
            e.printStackTrace();
        }
        
    }
    
    public static interface MessageHandler {
        public void handleMessage(String message);
    }
}
