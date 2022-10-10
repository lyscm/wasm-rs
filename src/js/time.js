export function get_now_date() {
    console.log("get_now_date called!");
    var current_date = new Date();
    return current_date.toDateString();
}