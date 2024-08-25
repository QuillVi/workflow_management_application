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
    title: "Làm việc nhóm",
    description:
        "  Dành cho nhóm giao tiếp và cộng tác\n                các dự án , vấn đề ",
  ),
  SplashCreenWordGroup1(
    image: "lib/images/listwork.png",
    title: " Danh sách công việc cần làm",
    description:
        "   Dễ dàng tạo và gán các mục công việc\n   cho bạn và các thành viên trong nhóm ",
  ),
];
