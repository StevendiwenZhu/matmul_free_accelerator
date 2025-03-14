import numpy as np
import matplotlib.pyplot as plt

# Sigmoid function
def sigmoid(x):
    return 1 / (1 + np.exp(-x))

# Signed decimal to fixed-point conversion
def signed_decimal_to_fixed(value, N, R):
    scale = 2 ** R
    scaled_value = int(round(value * scale))
    max_value = 2 ** (N - 1) - 1
    min_value = -2 ** (N - 1)
    return max(min(scaled_value, max_value), min_value)

# Signed fixed-point to decimal conversion
def signed_fixed_to_decimal(fixed_value, N, R):
    if fixed_value >= (1 << (N - 1)):  # If the value is negative in two's complement
        fixed_value -= (1 << N)
    return fixed_value / (2 ** R)

# Generate piecewise linear segments
def generate_piecewise_segments_fixed_point(min_val, max_val, num_segments, N, R):
    breakpoints = np.linspace(min_val, max_val, num_segments + 1)
    sigmoid_values = sigmoid(breakpoints)
    slopes = np.diff(sigmoid_values) / np.diff(breakpoints)
    intercepts = sigmoid_values[:-1] - slopes * breakpoints[:-1]
    lut = []
    for i in range(num_segments):
        lut.append({
            'index': i,
            'start': breakpoints[i],
            'end': breakpoints[i + 1],
            'slope': slopes[i],
            'intercept': intercepts[i],
            'slope_fixed': signed_decimal_to_fixed(slopes[i], N, R),
            'intercept_fixed': signed_decimal_to_fixed(intercepts[i], N, R),
        })
    return lut

# Print the LUT
def print_lut(lut, N, R):
    print(f"{'Index':<6} {'Start (Dec)':<15} {'Start (Fixed)':<15} {'End (Dec)':<15} {'End (Fixed)':<15} "
          f"{'Slope (Dec)':<15} {'Slope (Fixed)':<15} {'Intercept (Dec)':<15} {'Intercept (Fixed)':<15}")
    print("-" * 120)
    for segment in lut:
        start_fixed = signed_decimal_to_fixed(segment['start'], N, R)
        end_fixed = signed_decimal_to_fixed(segment['end'], N, R)
        print(f"{segment['index']:<6} "
              f"{segment['start']:<15.8f} {start_fixed:<15} "
              f"{segment['end']:<15.8f} {end_fixed:<15} "
              f"{segment['slope']:<15.8f} {segment['slope_fixed']:<15} "
              f"{segment['intercept']:<15.8f} {segment['intercept_fixed']:<15}")

def generate_synthesizable_systemverilog_pwl_lut(lut, N, R, filename="sigmoid_pwl.sv"):
    """
    Generates synthesizable SystemVerilog code for the PWL LUT implementation of the sigmoid function
    with clamping for out-of-range inputs, and saves it to a .sv file.
    
    Parameters:
        lut (list): The lookup table with segment details, including fixed-point values.
        N (int): Total number of bits for fixed-point representation.
        R (int): Number of fractional bits for fixed-point representation.
        filename (str): Name of the output SystemVerilog file.
    """
    sv_code = []
    sv_code.append(f"// Module generated by generators/pwl_sigmoid.py")
    sv_code.append(f"module sigmoid_unit #(")
    sv_code.append(f"    parameter N = {N},")
    sv_code.append(f"    parameter R = {R}")
    sv_code.append(f") (")
    sv_code.append(f"    input logic signed [N-1:0] x,")
    sv_code.append(f"    output logic signed [N-1:0] y")
    sv_code.append(f");")
    sv_code.append("")
    sv_code.append(f"    // LUT for slopes")
    sv_code.append(f"    logic signed [N-1:0] slope [{len(lut) - 1}:0];")
    # sv_code.append(f"    initial begin")
    for i, segment in enumerate(lut):
        sv_code.append(f"    assign slope[{i}] = {segment['slope_fixed']};")
    # sv_code.append(f"    end")
    sv_code.append("")
    sv_code.append(f"    // LUT for intercepts")
    sv_code.append(f"    logic signed [N-1:0] intercept [{len(lut) - 1}:0];")
    # sv_code.append(f"    initial begin")
    for i, segment in enumerate(lut):
        sv_code.append(f"    assign intercept[{i}] = {segment['intercept_fixed']};")
    # sv_code.append(f"    end")
    sv_code.append("")
    sv_code.append(f"    // Breakpoints for segment selection")
    sv_code.append(f"    logic signed [N-1:0] breakpoints [{len(lut)}:0];")
    # sv_code.append(f"    initial begin")
    for i, segment in enumerate(lut):
        sv_code.append(f"    assign breakpoints[{i}] = {signed_decimal_to_fixed(segment['start'], N, R)};")
    sv_code.append(f"    assign breakpoints[{len(lut)}] = {signed_decimal_to_fixed(lut[-1]['end'], N, R)};")
    # sv_code.append(f"    end")
    sv_code.append("")
    sv_code.append(f"    logic signed [N-1:0] segment_slope;")
    sv_code.append(f"    logic signed [N-1:0] segment_intercept;")
    sv_code.append("")
    sv_code.append(f"    always_comb begin")
    sv_code.append(f"        segment_slope = 0;")
    sv_code.append(f"        segment_intercept = 0;")
    sv_code.append("")
    sv_code.append(f"        // Clamp input outside range")
    sv_code.append(f"        if (x < breakpoints[0]) begin")
    sv_code.append(f"            y = 0;  // Sigmoid approaches 0 for -inf")
    sv_code.append(f"        end else if (x >= breakpoints[{len(lut)}]) begin")
    sv_code.append(f"            y = (1 << R);  // Sigmoid approaches 1 for +inf (1.0 in fixed-point)")
    sv_code.append(f"        end else begin")
    sv_code.append(f"            // Find the appropriate segment")
    sv_code.append(f"            for (int i = 0; i < {len(lut)}; i++) begin")
    sv_code.append(f"                if (x >= breakpoints[i] && x < breakpoints[i + 1]) begin")
    sv_code.append(f"                    segment_slope = slope[i];")
    sv_code.append(f"                    segment_intercept = intercept[i];")
    sv_code.append(f"                end")
    sv_code.append(f"            end")
    sv_code.append(f"            // Calculate the output")
    sv_code.append(f"            y = ((segment_slope * x) >>> R) + segment_intercept;")
    sv_code.append(f"        end")
    sv_code.append(f"    end")
    sv_code.append(f"endmodule")
    
    with open(filename, "w") as file:
        file.write("\n".join(sv_code))


# Plotting function
def plot_pwl_approximation(lut, min_val, max_val, N, R):
    x = np.linspace(min_val - 1, max_val + 1, 1000)
    y_true = sigmoid(x)
    y_approx = []
    for value in x:
        segment = next(
            (seg for seg in lut if seg['start'] <= value < seg['end']),
            lut[-1]
        )
        slope = signed_fixed_to_decimal(segment['slope_fixed'], N, R)
        intercept = signed_fixed_to_decimal(segment['intercept_fixed'], N, R)
        y_approx.append(slope * value + intercept)

    plt.figure(figsize=(10, 6))
    plt.plot(x, y_true, label="True Sigmoid", linewidth=2)
    plt.plot(x, y_approx, label="Piecewise Approximation", linestyle="--")
    plt.title("Piecewise Linear Approximation of Sigmoid Function")
    plt.xlabel("Input")
    plt.ylabel("Sigmoid Output")
    plt.legend()
    plt.grid(True)
    plt.show()

# Main Execution
min_val = -6
max_val = 6
num_segments = 2 ** 8
N = 16
R = 6

# Generate LUT
lut_fixed_point = generate_piecewise_segments_fixed_point(min_val, max_val, num_segments, N, R)

# Print LUT
print_lut(lut_fixed_point, N, R)

# Plot the approximation
plot_pwl_approximation(lut_fixed_point, min_val, max_val, N, R)

# Generate and save SystemVerilog
generate_synthesizable_systemverilog_pwl_lut(lut_fixed_point, N, R, filename="../verilog/sigmoid_unit.sv")
