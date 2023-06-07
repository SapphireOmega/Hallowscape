#ifndef PLAYER_H
#define PLAYER_H

#include <godot_cpp/godot.hpp>
#include <godot_cpp/classes/input.hpp>
#include <godot_cpp/classes/sprite2d.hpp>
#include <godot_cpp/classes/area2d.hpp>
#include <godot_cpp/classes/collision_shape2d.hpp>

#include <map>

union InputValue {
	int magnitude;
	bool active;
};

enum InputAxis { x_input };

namespace godot {

	class Player : public Area2D {
		GDCLASS(Player, Area2D)
		Sprite2D *_sprite;
		CollisionShape2D *_collision_shape;
		Input *_player_input;
	private:
		auto get_input() -> std::map<InputAxis, InputValue>;
	protected:
		static auto _bind_methods() -> void;
	public:
		real_t speed;
		Player();
		~Player();
		auto _ready() -> void;
		auto _process(double delta) -> void;
	};

}

#endif  // PLAYER_H
