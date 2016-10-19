class MoviesController < ApplicationController
  
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    @redir = 0
    @movies = Movie.all
    
    if(@selected != nil)
      @movies = @movies.find_all{ |m| @selected.has_key?(m.rating) and  @selected[m.rating]==true}      
    end
    
    if (params.has_key?(:sort))
      session[:sort] = params[:sort]
      @sort = params[:sort]
      @movies = Movie.order(@sort)
    elsif session.has_key?(:sort)
      params[:sort] = session[:sort]
      @redir = 1
      # @movies = Movie.all
    end
    
    if (params[:ratings] != nil)
      session[:ratings] = params[:ratings]
      @movies = @movies.find_all{ |m| params[:ratings].has_key?(m.rating) }
    elsif session.has_key?(:ratings)
      params[:ratings] = session[:ratings]
      @redir = 1
    end
    
    if (@redir == 1)
      redirect_to movies_path(:sort => params[:sort], :ratings => params[:ratings])
    end
    
    @selected = {}
    @all_ratings = ['G', 'PG', 'PG-13', 'R']
    
    @all_ratings.each { |rating|
      if params[:ratings] == nil
        @selected[rating] = false
      else
        @selected[rating] = params[:ratings].has_key?(rating)
      end
    }
    
    if params[:ratings] != nil
      @movies = @movies.find_all{ |m| params[:ratings].has_key?(m.rating)}
    end
    
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
  
  helper_method :get_dynamic_class
  def get_dynamic_class(class_name)
    if (@sort == class_name)
      return 'hilite'
    else
      return nil
    end
  end
end
