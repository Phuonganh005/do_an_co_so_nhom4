// 1. Định nghĩa
sig Student {}

sig Course {
    prereq: lone Course
}

// 2. Trạng thái hệ thống
one sig University {
    passed: Student -> Course,
    enrolled: Student -> Course
}

// 3. Không cho môn là tiên quyết của chính nó
fact NoSelfPrereq {
    no c: Course | c in c.^prereq
}

// 4. Quy tắc đăng ký hợp lệ
fact ValidRegistration {
    all s: Student, c: Course |
        c in s.(University.enrolled) =>
        (no c.prereq or c.prereq in s.(University.passed))
}

// 5. Giới hạn tối đa 5 môn đăng ký
fact LimitCourseRegistration {
    all s: Student |
        #(s.(University.enrolled)) <= 5
}

// 6. Setup để Alloy tạo ví dụ
pred ExampleRegistration {
    some s0: Student |
        #(s0.(University.enrolled)) = 5
}

// 7. Chạy tìm instance
run ExampleRegistration for 2 Student, 6 Course, exactly 1 University
