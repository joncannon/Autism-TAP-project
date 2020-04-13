<h1>README.md</h1>
  
  <h2>What is each file?</h2>
  1. bin_maker.py is a python script that generates three bin descriptor files
  2. bins_words_separate.txt is a bin descriptor generate by bin_maker.py
  3. bins_words_thirds.txt is a bin descriptor generate by bin_maker.py
  4. bins_words_together.txt is a bin descriptor generate by bin_maker.py
  5. Detection_reaction_bin_descriptor.txt is a bin descriptor used to analyze tap and reaction events
  
  The first three bin descriptor files (all beginning with "bins_words") are used for N400 extraction in the story task
  
  <h2>How do I used bin desciptors</h2>
  See the instructions in the pdf in EEG/Pipeline_notes directory
  
  <h2>How do I generate the three bin descripstors<h2>
  Edit bin_maker.py to make sure cloze is set as a python array of cloze values with the value in the first index corresponding to event code 1000, the cloze value in the second index corresponding to 2000, and so on. Everything else should be handled automatically! Save the file, and run the script bin_maker.py. You can do this by going to the directory that has the file in terminal/command line and running the command "python3 bin_maker.py" or "python bin_maker.py" whichever one words for you.
  
  If you have any questions contact awang23@mit.edu
  
  
