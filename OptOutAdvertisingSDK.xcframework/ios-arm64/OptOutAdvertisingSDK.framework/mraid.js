const createErrorFunction = (prop) => () => {
	mraid.error(prop);
	return {};
}

const mraidFunctionProxy = (target, prop) => {
	// Check if the requested function exists
	if(target[prop] === undefined) {
		// If the requested function is undefined, return a error function
		return createErrorFunction(prop);
	} else {
		// If does exist, return the originally requested function
		return target[prop];
	}
};

// Initially initalize mraid as proxy
mraid = new Proxy({}, { get : mraidFunctionProxy });

const bridge = {
	storage: {},
	state: "default"
};

bridge.call = (command) => {
	window.webkit.messageHandlers.bridge.postMessage(JSON.stringify(command));
}

bridge.callback = (callback) => {

	if(bridge.storage[callback] !== null) {
		mraid.log("Calling callback " + callback);
		bridge.storage[callback]()
	}
}

bridge.viewableChange = (isViewable) => {
    if(bridge.storage["viewableChange"] !== null) {
        mraid.log("Calling viewableChange with isVisible:" + isViewable);
        bridge.storage["viewableChange"](isViewable)
    }
}

mraid.getVersion = () => {
    return "2.0"
}
/**
 Defines the open functionality used by mraid
 */
mraid.open = (url) => {

	const cmd = {
		name: "open",
		data: {
			url: url
		}
	};

	bridge.call(cmd);
}

mraid.log = (message) => {

	const cmd = {
		name: "log",
		data: {
			message: message,
		},
	};

	bridge.call(cmd);
}

mraid.getState = () => {
	return bridge.state;
}

mraid.isViewable = () => {
	return bridge.state == "default"
}

/**
 Defines the addEventListener function used by mraid
 */
mraid.addEventListener = (event, callback) => {

	const cmd = {
		name: "add-event",
		data: {
			name: event,
		},
	};

	bridge.storage[event] = callback;
	bridge.call(cmd);
}

mraid.removeEventListener = (event, callback) => {

	const cmd = {
		name: "remove-event",
		data: {
			name: event,
		},
	};

	bridge.storage[event] = null;
	bridge.call(cmd);
}

mraid.error = (message) => {

	const cmd = {
		name: "error",
		data: {
			message: message,
		},
	};

	bridge.call(cmd);
}
mraid.setGamblingPreference = (preference) => {
    const cmd = {
        name: "setGamblingPreference",
    data: {
        preference: preference,
        
        },
    };
    bridge.call(cmd);
}

window.mraid = mraid;
window.open = mraid.open;
console.log = mraid.log;
console.debug = mraid.log;
