
export var errorsInOpenFiles: TabWithGotoPositions = { members: [] };
export var buildOutput: TabWithGotoPositions = { members: [] };
export var referencesOutput: TabWithGotoPositions = { members: [] };

/** This *must* always be set */
export var activeList: TabWithGotoPositions = errorsInOpenFiles;

export function gotoLine(filePath: string, line: number, col: number, list: TabWithGotoPositions) {
    var activeFile,
        activeEditor = atom.workspace.getActiveTextEditor();
    if (activeEditor !== undefined && activeEditor !== null) {
        activeFile = activeEditor.getPath();
    }

    if (filePath !== activeFile) {
        atom.workspace.open(filePath, {
            initialLine: line - 1,
            initialColumn: col
        });
    } else {
        atom.workspace.getActiveTextEditor().cursors[0].setBufferPosition([line - 1, col]);
    }

    list.lastPosition = { filePath, line, col };
}

/**
 * Uses `activeList` to go to the next error or loop back
 * Storing `lastPosition` with the list allows us to be lazy elsewhere and actively find the element here
 */
function findCurrentIndexInList(): number {
    // Early exit if no members
    if (!activeList.members.length) {
        atom.notifications.addInfo('AtomTS: no go-to members in active list');
        return -1;
    }
    // If we don't have a lastPosition then first is the last position
    if (!activeList.lastPosition)
        return 0;

    var lastPosition = activeList.lastPosition;
    var index = indexOf(activeList.members, (item) => item.filePath == lastPosition.filePath && item.line == lastPosition.line);

    // if the item has since been removed go to 0
    if (index == -1) {
        return 0;
    }
    return index;
}

/** Uses `activeList` to go to the next position or loop back */
export function gotoNext() {
    var currentIndex = findCurrentIndexInList();
    if (currentIndex == -1) return;

    var nextIndex = currentIndex + 1;
    // If next is == length then loop to zero
    if (nextIndex == activeList.members.length) {
        nextIndex = 0;
    }

    var next = activeList.members[nextIndex];
    gotoLine(next.filePath, next.line, next.col, activeList);
}

export function gotoPrevious() {
    var currentIndex = findCurrentIndexInList();
    if (currentIndex == -1) return;

    var previousIndex = currentIndex - 1;
    // If next is == -1 then loop to length
    if (previousIndex == -1) {
        previousIndex = activeList.members.length - 1;
    }

    var previous = activeList.members[previousIndex];
    gotoLine(previous.filePath, previous.line, previous.col, activeList);
}


/**
 * Utility Return index of element in an array
 */
function indexOf<T>(items: T[], filter: (item: T) => boolean): number {
    for (var i = 0; i < items.length; i++) {
        if (filter(items[i])) {
            return i;
        }
    }
    return -1;
}
