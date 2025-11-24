# ECE 370: Signals and Systems
## Lecture Notes and Course Materials

This repository contains comprehensive lecture notes and examples for ECE 370: Signals and Systems at The University of Alabama.

Download [here](https://github.com/zhengnanli/ss-notes/releases/latest/download/lec.pdf)!

### 📚 Course Information

**Course**: ECE 370 - Signals and Systems  
**Institution**: The University of Alabama  
**Department**: Electrical and Computer Engineering  
**Instructor**: Dr. Zhengnan Li  
**Semester offered**: Fall 2025

### 🎯 Course Description

This course provides a comprehensive introduction to signals and systems analysis, covering both continuous-time and discrete-time domains. Students will learn fundamental concepts including Linear Time-Invariant (LTI) systems, Fourier analysis, sampling theory, and their applications in engineering.

### 📖 Topics Covered

1. **Introduction to Signals and Systems**
   - Signal classification and properties
   - System properties and representations
   - Energy and power signals

2. **Linear Time-Invariant (LTI) Systems**
   - Impulse response and convolution
   - System stability and causality
   - Differential and difference equations

3. **Fourier Analysis**
   - Fourier series for periodic signals
   - Continuous-time Fourier transform (CTFT)
   - Discrete-time Fourier transform (DTFT)
   - Fast Fourier transform (FFT) applications

6. **Sampling and Reconstruction**
   - Nyquist-Shannon sampling theorem
   - Aliasing and anti-aliasing filters
   - Practical ADC/DAC considerations

### 🛠️ Building the Notes

The lecture notes are written in [Typst](https://typst.app/), a modern typesetting system. To compile the notes:

#### Prerequisites -- Install Typst: 
   ```bash
   # On macOS with Homebrew
   brew install typst
   
   # On Arch Linux
   pacman -S typst
   
   # Or download from https://github.com/typst/typst/releases
   ```

#### Compilation

To compile individual lecture notes:
```bash
cd lectures
typst compile lec.typ
```

Compiled PDFs will be generated in the current directory.

### 🔗 Useful Resources

- **Primary Textbook**: *Signals and Systems* by Oppenheim and Willsky
- **Secondary Reference**: *Signals and Systems* by Simon Haykin and Barry Van Veen
- **MATLAB Documentation**: [Signal Processing Toolbox](https://www.mathworks.com/products/signal.html)
- **Interactive Demos**: [MIT OpenCourseWare 6.003](https://ocw.mit.edu/courses/6-003-signals-and-systems-fall-2011/)
- **Python Alternative**: [SciPy Signal Processing Tutorial](https://docs.scipy.org/doc/scipy/tutorial/signal.html)

### 🤝 Contributing

Contributions to improve the notes are welcome! Please:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/improvement`)
3. Commit your changes (`git commit -am 'Add new example'`)
4. Push to the branch (`git push origin feature/improvement`)
5. Open a Pull Request

For error corrections, please open an issue describing the error and its location.

### 📧 Contact

Dr. Zhengnan Li  
Assistant Professor  
Department of Electrical and Computer Engineering  
The University of Alabama  
Email: zhengnan.li (at) ua.edu  

### 📄 License

This work is licensed under a [Creative Commons Attribution-ShareAlike 4.0 International License](http://creativecommons.org/licenses/by-sa/4.0/).

Code examples are licensed under the [MIT License](LICENSE-CODE).

### 🙏 Acknowledgments

- The University of Alabama ECE Department
- Students who provided feedback and corrections
- Open-source signal processing community
- Contributors to the Typst typesetting system

---

*Last Updated: November 2024*  
*Version: Fall 2025*
