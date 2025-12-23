//Button code inspired from: https://gamemaker.io/en/tutorials/how-to-make-buttons
//Was doing everything in Step event, until I watched this video: https://www.youtube.com/watch?v=ADfu4hjo_cI
//Which made me trust my instincts and separate into multiple events
//TODO see if this has good performance, and maybe leave a nice comment under the video if it does

hovering = false;
//Necessary to prevent clicking in one place, dragging over to another button, and releasing to click that button
clicked = false;

//Gets overridden in instance creation code
function clicked_action() {}
