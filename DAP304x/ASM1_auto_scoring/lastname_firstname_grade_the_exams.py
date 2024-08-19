import os
# Lấy đường dẫn tuyệt đối của script Python đang thực thi
script_path = os.path.abspath(__file__)
# Lấy đường dẫn thư mục chứa file script
script_dir = os.path.dirname(script_path)
# Đặt thư mục làm việc hiện tại là thư mục chứa file script
os.chdir(script_dir)

import numpy as np
# Khởi tạo Tiêu chí đánh giá cho trước, biến đổi thành List để dễ xử lý dữ liệu
answer_key = "B,A,D,D,C,B,D,A,C,C,D,B,A,B,A,C,B,D,A,C,A,A,B,D,D"
answer_key = answer_key.split(',')

while True:
  file_name = input("Enter a class file to grade (i.e. class1 for class1.txt):")

  # Kiểm tra input được nhập để thêm hậu tố định dạng file nếu cần
  if '.txt' not in file_name:
    file_name += '.txt'
  
  # Mở tệp tin với xử lý ngoại lệ exception-handling
  try:
    with open(file_name,"r") as class_file:
      print("Successfully opened "+file_name)
      
      # Khai báo khởi tạo biến để xử lý dữ liệu
      num_lines = 0
      invalid_lines = 0
      scores = []              # danh sách List tổng hợp điểm của cả lớp
      studentID = []           # danh sách List mã học sinh của cả lớp
      num_highscore = 0
      # Khai báo tạo mảng array 1D gồm 25 ký tự kiểu int, giá trị khởi tạo = 0
      # mảng 25 giá trị tương ứng với 25 đáp án, đếm cộng dồn khi skip/ wrong
      question_skips = np.zeros(25, dtype=int)
      question_wrong = np.zeros(25, dtype=int)
      print("\n***** ANALYZING *****")

      # Kiểm tra tính hợp lệ của từng dòng trong class_file
      for line in class_file:
        # Đếm số dòng trong class_file
        num_lines += 1
        rubric = line.strip().split(',') # .strip() để xóa khoảng cách spaces thừa trước/ sau của dòng
        # Kiểm tra không thỏa mãn điều kiện có chính xác 26 ký tự
        if len(rubric) != 26:
          print("Line",num_lines,"does not contain exactly 26 values")
          print(line)
          invalid_lines += 1
        # Kiểm tra không thỏa mãn điều kiện về ID N#
        elif rubric[0][0] != 'N' or len(rubric[0]) != 9 or not rubric[0][1:].isdigit():
          print("Line",num_lines,"contains invalid ID N#")
          print(line)
          invalid_lines += 1
        # Tính điểm từng học sinh hợp lệ và tổng hợp số liệu
        else:
          studentID.append(rubric[0])   # Thêm mã học sinh vào List studentID
          answers = rubric[1:]          # Ghi nhận câu trả lời của học sinh đó
          score = 0                     # Điểm bắt đầu từ 0
          # Lặp với mỗi chỉ số, trả lời trong bài làm của học sinh trên
          for idx, answer in enumerate(answers):
            if answer == "":
              question_skips[idx] += 1   # Tăng số lần câu tương ứng bị bỏ qua (để trông câu trả lời)
            elif answer != answer_key[idx]:
              score -= 1
              question_wrong[idx] += 1   # Tăng số lần câu tương ứng bị trả lời sai
            else:
              score += 4
          # Tăng số đếm học sinh có điểm cao (>80 điểm) nếu thỏa mãn điều kiện
          if score > 80:
            num_highscore += 1
          scores.append(score)   # Thêm điểm của học sinh vào List scores
      scores = np.array(scores)   # Chuyển đổi List scores thành mảng numpy để dễ dàng thống kê
      if invalid_lines == 0:
        print("No errors found!")
      print("\n***** REPORTS *****")
      print("Number of lines in the file:",num_lines)
      print("Number of invalid lines:",invalid_lines)
      print("\nTotal number of students with highscore (>80): ", num_highscore)
      print("Mean (average) score: ", sum(scores)/len(scores))
      print("Highest score: ", np.max(scores))
      print("Lowest score: ", np.min(scores))
      print("Range of scores: ", np.max(scores)-np.min(scores))
      print("Median score: ", np.median(scores))

      # Tìm câu trả lời bị bỏ qua nhiều nhất, và tỷ lệ
      max_skip = np.max(question_skips)
      skip_ratio = max_skip / len(answers)
      print("\nMost skipped questions: question - number of skips - ratio")
      for question, skip in enumerate(question_skips):
        if skip == max_skip:
          print(' ',question+1, max_skip, skip_ratio)
          # question+1 vì vòng lặp đếm từ 0, mà STT của câu hỏi đếm từ 1

      # Tìm câu trả lời bị sai nhiều nhất, và tỷ lệ
      max_wrong = np.max(question_wrong)
      wrong_ratio = max_wrong / len(answers)
      print("\nMost wrong questions: question - number of wrongs - ratio")
      for question, wrong in enumerate(question_wrong):
        if wrong == max_wrong:
          print(' ',question+1, max_wrong, wrong_ratio)
          # question+1 vì vòng lặp đếm từ 0, mà STT của câu hỏi đếm từ 1
    class_file.close()

    # Tạo file kết quả chấm điểm mã học sinh, điểm số
    file_result = file_name.replace(".txt","_grades.txt")
    with open(file_result,"w") as result_file:
      for i in range(len(studentID)):
        result_file.write(studentID[i] + ", " + str(scores[i]) + "\n")
      result_file.close()

    break
  except FileNotFoundError:
    print("File cannot be found. Please try again!")