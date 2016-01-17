function LuaMain()
	engine = EngineSingleton:get_singleton()
	l_RR = engine:get_renderableobjects_manager()
	l_RR:load("funciona")
end