/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package main;

import javax.json.Json;
import javax.json.JsonObject;
import javax.websocket.EncodeException;
import javax.websocket.Encoder;
import javax.websocket.EndpointConfig;

/**
 *
 * @author namin
 */
public class MessageEncode implements Encoder.Text<Message>{

    @Override
    public String encode(Message message) throws EncodeException {
        JsonObject jsonObject = Json.createObjectBuilder()
                .add("subject",message.getSubject())
                .add("content", message.getContent()).build();
        return jsonObject.toString();
    }

    @Override
    public void init(EndpointConfig config) {
        
    }

    @Override
    public void destroy() {
        
    }
    
}
