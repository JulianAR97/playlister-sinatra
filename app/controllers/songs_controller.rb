require 'rack-flash'

class SongsController < ApplicationController
    use Rack::Flash
    get '/songs' do
        erb :'songs/index'
    end

    get '/songs/new' do
        erb :'songs/new'
    end

    get '/songs/:slug' do
        @song = Song.find_by_slug(params[:slug])
        if @song
            erb :'songs/show'
        else
            redirect '/songs'
        end
    end

    get '/songs/:slug/edit' do
        @song = Song.find_by_slug(params[:slug])
        erb :'songs/edit'
    end

    post '/songs' do
        @song = Song.create(name: params[:name])
        @song.artist = Artist.find_or_create_by(name: params[:artist])
        @song.genre_ids = params[:genres]
        @song.save
        flash[:message] = "Successfully created song."
        redirect "/songs/#{@song.slug}"
    end

    patch '/songs/:slug' do
        @song = Song.find_by_slug(params[:slug])
        @song.artist = Artist.find_or_create_by(name: params[:artist])
        @song.genre_ids = params[:genres]
        @song.save
        flash[:message] = "Successfully updated song."
        redirect "/songs/#{@song.slug}"
    end
end
