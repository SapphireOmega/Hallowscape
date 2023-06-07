#include "player.hpp"

#include <godot_cpp/core/class_db.hpp>

using namespace godot;

auto Player::_bind_methods() -> void {
}

Player::Player() {
	_player_input = Input::get_singleton();
	speed = 500.0;
}

Player::~Player() {
}

auto Player::get_input() -> std::map<InputAxis, InputValue> {
	return {
		{ x_input, { _player_input->is_action_pressed("ui_right") - _player_input->is_action_pressed("ui_left") } }
	};
}

auto Player::_ready() -> void {
	_sprite = get_node<Sprite2D>("Sprite2D");
	_collision_shape = get_node<CollisionShape2D>("CollisionShape2D");
}

auto Player::_process(double delta) -> void {
	Vector2 velocity = Vector2(get_input()[x_input].magnitude, 0).normalized() * speed;
	Vector2 new_position = get_position() + velocity * (real_t)delta;
	set_position(new_position);
}
