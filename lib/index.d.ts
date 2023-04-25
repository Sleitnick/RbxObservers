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
		callback: (value: AttributeValue) => () => void,
		guard?: (value: AttributeValue) => boolean,
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
		callback: (instance: T) => () => void,
		ancestors?: Instance[],
	) => () => void;
}

declare const Observers: Observers;

export = Observers;
