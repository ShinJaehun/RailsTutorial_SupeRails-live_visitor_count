class RoomChannel < Turbo::StreamsChannel
    def subscribed
        super
        # binding.b
        visitors_online = Kredis.unique_list ["room", params[:room_id]].join # 여기 join이 들어가는 이유는?
        visitors_online << session_user

        Turbo::StreamsChannel.broadcast_update_to(
            verified_stream_name_from_params,
            target: "room-#{params[:room_id]}-visitors-count",
            html: visitors_online.elements.count
        )

        # binding.b
    end

    def unsubscribed
        visitors_online = Kredis.unique_list ["room", params[:room_id]].join
        visitors_online.remove session_user
        
        Turbo::StreamsChannel.broadcast_update_to(
            verified_stream_name_from_params,
            target: "room-#{params[:room_id]}-visitors-count",
            html: visitors_online.elements.count
        )
    end
end