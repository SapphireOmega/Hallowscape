#include "Player.hpp"
#include <godot_cpp/core/class_db.hpp>

using namespace godot;

void Player::_bind_methods() {}

Player::Player() {
	time_passed = 0.0;
}

Player::~Player() {}

void Player::_process(double delta) {
	time_passed += delta;

	Vector2 new_position = Vector2(10.0 + (10.0 * sin(time_passed * 2.0)),
	                               10.0 + (10.0 * cos(time_passed * 1.5)));

	set_position(new_position);
}
