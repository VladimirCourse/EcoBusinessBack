OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

class PlannerController < ApplicationController
    
    # GET /planner/flights
    def flights
        render json: PlannerHelper.flights(params[:origin], params[:destination], params[:date])
    end

    # GET /planner/trains
    def trains
        render json: PlannerHelper.trains(params[:origin], params[:destination], params[:date])
    end

    # GET /planner/buses
    def buses
        render json: PlannerHelper.buses(params[:origin], params[:destination], params[:date])
    end

    # GET /planner/hotels
    def hotels
        render json: PlannerHelper.hotels(params[:destination], params[:arrival], params[:departure])
    end

    # GET /planner/transfer/car
    def car_transfer
        render json: PlannerHelper.car_transfer(params[:destination])
    end

    # GET /planner/autocomplete
    def autocomplete
        response = HTTParty.get('https://maps.googleapis.com/maps/api/place/autocomplete/json',
            query: {
                key: '',
                input: params[:input],
                sessiontoken: request.remote_ip
            }
        )

        if response.code == 200
            auto = JSON.parse(response.body)['predictions']
            render json: auto.map{|p| { description: p['description'], place_id: p['place_id'] }}
        else
            render json: []
        end
    end
  private
    # Use callbacks to share common setup or constraints between actions.

end

  