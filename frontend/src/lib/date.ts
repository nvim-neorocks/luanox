
export function parseDate(dateString: string): Date {
    if (dateString.includes("day")) {
    const days = parseInt(dateString.split(" ")[0]);
    const now = new Date();
    return new Date(now.getTime() - days * 24 * 60 * 60 * 1000);
    } else if (dateString.includes("week")) {
    const weeks = parseInt(dateString.split(" ")[0]);
    const now = new Date();
    return new Date(now.getTime() - weeks * 7 * 24 * 60 * 60 * 1000);
    } else if (dateString.includes("month")) {
    const months = parseInt(dateString.split(" ")[0]);
    const now = new Date();
    return new Date(
        now.getFullYear(),
        now.getMonth() - months,
        now.getDate()
    );
    } else if (dateString.includes("year")) {
    const years = parseInt(dateString.split(" ")[0]);
    const now = new Date();
    return new Date(
        now.getFullYear() - years,
        now.getMonth(),
        now.getDate()
    );
    } else {
    return new Date();
    }
}