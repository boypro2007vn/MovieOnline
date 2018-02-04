/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package main;

import entity.Movies;

/**
 *
 * @author namin
 */
public class MovieView {
    private Movies movie;
    private int view;

    public MovieView(Movies movie, int view) {
        this.movie = movie;
        this.view = view;
    }

    public Movies getMovie() {
        return movie;
    }

    public void setMovie(Movies movie) {
        this.movie = movie;
    }

    public int getView() {
        return view;
    }

    public void setView(int view) {
        this.view = view;
    }
    
    
}
