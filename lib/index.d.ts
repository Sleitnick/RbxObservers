/**
 * A collection of observer utility functions.
 */
interface Observers {
	/**
	 * Observers an attribute on the given instance.
	 *
	 * ```ts
	 * const stop = Observers.observeAttribute(workspace.Model, "MyAttribute", (value) => {
	 * 	// Do something wih `value`.
	 * 	return () => {
	 * 		// Cleanup. Runs when the value changes.
	 * 	};
	 * });
	 *
	 * // Optionally, stop the observer from observing anything, and clean up current observations:
	 * stop();
	 * ```
	 *
	 * @param instance The instance where the attribute lives.
	 * @param name The name of the attribute.
	 * @param callback Used to observe the value of the attribute.
	 * @param guard Optional guard predicate. If supplied, returns `true`/`false`. Observer callback only runs if this returns `true`.
	 * @returns Cleanup function.
	 */
	observeAttribute: (
		instance: Instance,
		name: string,
		callback: (value: AttributeValue) => (() => void) | void,
		guard?: (value: AttributeValue) => boolean,
	) => () => void;

	/**
	 * Observers a property on the given instance.
	 *
	 * ```ts
	 * const stop = Observers.observeAttribute(workspace.Model, "MyAttribute", (value) => {
	 * 	// Do something wih `value`.
	 * 	return () => {
	 * 		// Cleanup. Runs when the value changes.
	 * 	};
	 * });
	 *
	 * // Optionally, stop the observer from observing anything, and clean up current observations:
	 * stop();
	 * ```
	 *
	 * @param instance The instance where the attribute lives.
	 * @param property The property name.
	 * @param callback Used to observe the value of the property.
	 * @returns Cleanup function.
	 */
	observeProperty: <T extends Instance, P extends InstancePropertyNames<T>>(
		instance: T,
		property: P,
		callback: (value: T[P]) => (() => void) | void,
	) => () => void;

	/**
	 * Observe instances with the given tag.
	 *
	 * ```ts
	 * Observers.observeTag("MyTag", (instance) => {
	 * 	// Do something with `instance`.
	 * 	return () => {
	 * 		// Cleanup.
	 * 		// The instance is either gone, lost its tag, or moved to a non-allowed ancestor (if supplied).
	 * 	};
	 * });
	 * ```
	 *
	 * @param tag CollectionService tag.
	 * @param callback Observer function. Runs for every instance with the given tag.
	 * @param ancestors Optional inclusion list of allowed ancestors. The default is to allow all ancestors.
	 * @returns Cleanup function.
	 */
	observeTag: <T extends Instance = Instance>(
		tag: string,
		callback: (instance: T) => (() => void) | void,
		ancestors?: Instance[],
	) => () => void;

	/**
	 * Observes players in the game.
	 *
	 * ```ts
	 * Observers.observePlayer((player) => {
	 * 	print(`${player.Name} entered the game`);
	 *
	 * 	return () => {
	 * 		print(`${player.Name} left the game`);
	 * 	};
	 * });
	 * ```
	 *
	 * @param callback Observer called for each player. Optional cleanup function can be returned, which is called when the player leaves the game.
	 * @returns Cleanup function, which stops observing players.
	 */
	observePlayer: (callback: (player: Player) => ((exitReason: Enum.PlayerExitReason) => void) | void) => () => void;

	/**
	 * Observers characters in the game. An optional list of `allowedPlayers` can be provided. Otherwise, characters from all players are observed.
	 *
	 * ```ts
	 * Observers.observeCharacter((player, character) => {
	 * 	// Character was spawned
	 * 	print(`Character spawned for ${player.Name}`);
	 *
	 * 	// Get the humanoid:
	 * 	const humanoid = character.WaitForChild("Humanoid", 60);
	 *
	 * 	// Listen for humanoid Died event:
	 * 	let humanoidDiedConn: RBXScriptConnection | undefined;
	 * 	if (humanoid !== undefined) {
	 * 		humanoidDiedConn = humanoid.Died.Connect(() => {
	 * 			print(`${player.Name}'s character died`);
	 * 		});
	 * 	}
	 *
	 * 	// Handle when character is removed (or observer is stopped):
	 * 	return () => {
	 * 		print(`Character removed for ${player.Name}`);
	 * 		humanoidDiedConn?.Disconnect();
	 * 	};
	 * });
	 * ```
	 *
	 * @param callback Observer called for each character. Optional cleanup function can be returned, which is called when the character is removed.
	 * @returns Cleanup function, which stops observing characters.
	 */
	observeCharacter: <C extends Model = Model>(
		callback: (player: Player, character: C) => (() => void) | void,
		allowedPlayers?: Player[],
	) => () => void;

	/**
	 * Observers the local character in the game. This can only be called from the client.
	 * 
	 * ```ts
	 * observeLocalCharacter((character) => {
	 * 	print("Local character added");
	 * 	return () => {
	 * 		print("Local character removed");
	 * 	};
	 * });
	 * ```
	 * 
	 * @param callback Observer called for the local character. Optional cleanup function can be returned, which is called when the character is removed.
	 * @returns Cleanup function, which stops observing the local character.
	 */
	observeLocalCharacter: <C extends Model = Model>(callback: (character: C) => (() => void) | void) => () => void;

	/**
	 * Observes children of the given instance.
	 *
	 * ```ts
	 * Observers.observeChildren(workspace, (child) => {
	 * 	print(`Child added: ${child.Name}`);
	 * 	return () => {
	 * 		print(`Child removed: ${child.Name}`);
	 * 	};
	 * });
	 * ```
	 *
	 * @param instance The instance whose children to observe.
	 * @param callback Observer called for each child. Optional cleanup function can be returned, which is called when the child is removed.
	 * @returns Cleanup function, which stops observing children.
	 */
	observeChildren: (
		instance: Instance,
		callback: (child: Instance) => (() => void) | void,
	) => () => void;
}

declare const Observers: Observers;

export = Observers;
