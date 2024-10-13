class SplashCreenWordGroup1 {
  String image;
  String title;
  String description;

  SplashCreenWordGroup1(
      {required this.image, required this.title, required this.description});
}

List<SplashCreenWordGroup1> contents = [
  SplashCreenWordGroup1(
    image: "lib/images/work.png",
    title: "Teamwork",
    description:
        "  For teams to communicate and collaborate on\n                        projects and issues ",
  ),
  SplashCreenWordGroup1(
    image: "lib/images/listwork.png",
    title: " To Do List",
    description:
        "   Easily create and assign tasks to\n      you and your team members ",
  ),
];
