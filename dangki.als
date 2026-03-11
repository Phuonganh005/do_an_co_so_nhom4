// 1.định nghĩa
sig Student {}

sig Course {
prereq: lone Course // Một môn có tối đa (lone) một môn tiên quyết
}
// 2.Trạng thái hệ thống
one sig University {
passed: Student -> Course, // Sinh viên đã đậu môn nào
enrolled: Student -> Course // Sinh viên đang đăng ký môn nào
}
//3.ràng buộc logic
fact NoSelfPrereq {
// Một môn không thể là môn tiên quyết của chính nó (tránh vòng lặp)
no c: Course | c in c.^prereq // ^ là toán học bao đóng bắc cầu (transitive closure)
}

fact ValidRegistration {
// Quy tắc: Muốn đăng ký môn c, phải pass môn prereq của c
all s: Student, c: Course |
c in s.(University.enrolled) => (some p: c.prereq | p in s.(University.passed) or no c.prereq)
}
//4.ktra giả thuyết
assert AcademicIntegrity {
// Giả thuyết: Không sinh viên nào đang học một môn mà chưa pass môn tiên quyết
all s: Student, c: Course |
(c in s.(University.enrolled) and some c.prereq) => c.prereq in s.(University.passed)
}

// Lệnh thực thi
check AcademicIntegrity for 3 but 5 Course
