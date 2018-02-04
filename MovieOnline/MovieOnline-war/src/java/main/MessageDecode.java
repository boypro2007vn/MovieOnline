/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package main;

import java.io.StringReader;
import javax.json.Json;
import javax.json.JsonObject;
import javax.websocket.DecodeException;
import javax.websocket.Decoder;
import javax.websocket.EndpointConfig;

/**
 *
 * @author namin
 */
public class MessageDecode implements Decoder.Text<Message>{

    @Override
    public Message decode(String jsonMessage) throws DecodeException {
          JsonObject jsonObject = Json
                .createReader(new StringReader(jsonMessage)).readObject();
            Message message = new Message();
            message.setSubject(jsonObject.getString("subject"));
            message.setContent(jsonObject.getString("content"));
            return message;
    }

    @Override
    public boolean willDecode(String jsonMessage) {
        try {
      // Check if incoming message is valid JSON
            Json.createReader(new StringReader(jsonMessage)).readObject();
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    @Override
    public void init(EndpointConfig config) {
        
    }

    @Override
    public void destroy() {
        
    }
    
}
